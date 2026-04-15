#!/bin/bash
set -e

PZ_INSTALL_DIR="/home/pzuser/pzserver"
PZ_CONFIG_DIR="/home/pzuser/Zomboid"
CONFIG_TEMPLATES="/home/pzuser/config-templates"

echo "============================================"
echo " Project Zomboid Dedicated Server"
echo "============================================"

# --- Instalar/Atualizar servidor via SteamCMD ---
echo "[*] Atualizando servidor via SteamCMD..."

STEAMCMD_ARGS="+force_install_dir ${PZ_INSTALL_DIR} +login anonymous"

if [ -n "${PZ_BETA_BRANCH}" ]; then
    echo "[*] Beta branch: ${PZ_BETA_BRANCH}"
    STEAMCMD_ARGS="${STEAMCMD_ARGS} +app_update 380870 -beta ${PZ_BETA_BRANCH} validate"
else
    STEAMCMD_ARGS="${STEAMCMD_ARGS} +app_update 380870 validate"
fi

STEAMCMD_ARGS="${STEAMCMD_ARGS} +quit"

steamcmd ${STEAMCMD_ARGS}

echo "[*] Servidor atualizado com sucesso."

# --- Copiar configurações template (apenas no primeiro boot) ---
SERVER_DIR="${PZ_CONFIG_DIR}/Server"
SERVER_INI="${SERVER_DIR}/${PZ_SERVER_NAME}.ini"
SANDBOX_VARS="${SERVER_DIR}/${PZ_SERVER_NAME}_SandboxVars.lua"

mkdir -p "${SERVER_DIR}"

if [ -f "${CONFIG_TEMPLATES}/server.ini" ] && [ ! -f "${SERVER_INI}" ]; then
    echo "[*] Aplicando template server.ini -> ${PZ_SERVER_NAME}.ini"
    cp "${CONFIG_TEMPLATES}/server.ini" "${SERVER_INI}"
fi

if [ -f "${CONFIG_TEMPLATES}/sandbox-vars.lua" ] && [ ! -f "${SANDBOX_VARS}" ]; then
    echo "[*] Aplicando template sandbox-vars.lua -> ${PZ_SERVER_NAME}_SandboxVars.lua"
    cp "${CONFIG_TEMPLATES}/sandbox-vars.lua" "${SANDBOX_VARS}"
fi

# --- Configurar Mods da Workshop ---
WORKSHOP_FILE="${CONFIG_TEMPLATES}/workshop.txt"
WORKSHOP_DIR="${PZ_INSTALL_DIR}/steamapps/workshop/content/108600"

if [ -f "${WORKSHOP_FILE}" ]; then
    # Ler Workshop IDs do arquivo (ignora comentários e linhas vazias)
    WORKSHOP_IDS=""
    while IFS= read -r line; do
        line=$(echo "$line" | sed 's/#.*//' | tr -d '[:space:]')
        [ -z "$line" ] && continue
        [ -n "$WORKSHOP_IDS" ] && WORKSHOP_IDS="${WORKSHOP_IDS};"
        WORKSHOP_IDS="${WORKSHOP_IDS}${line}"
    done < "${WORKSHOP_FILE}"

    if [ -n "${WORKSHOP_IDS}" ]; then
        # Contar mods
        MOD_COUNT=$(echo "${WORKSHOP_IDS}" | tr ';' '\n' | sort -u | wc -l)
        echo "[*] Encontrados ${MOD_COUNT} Workshop IDs em workshop.txt"

        # Deduplicar
        WORKSHOP_IDS=$(echo "${WORKSHOP_IDS}" | tr ';' '\n' | sort -u | tr '\n' ';' | sed 's/;$//')

        # Download workshop items via SteamCMD (em lotes)
        echo "[*] Baixando mods da Workshop via SteamCMD..."
        IFS=';' read -ra WS_ARRAY <<< "${WORKSHOP_IDS}"
        BATCH_SIZE=50
        TOTAL=${#WS_ARRAY[@]}

        for ((i=0; i<TOTAL; i+=BATCH_SIZE)); do
            BATCH_NUM=$(( i/BATCH_SIZE + 1 ))
            TOTAL_BATCHES=$(( (TOTAL + BATCH_SIZE - 1) / BATCH_SIZE ))
            echo "[*] Lote ${BATCH_NUM}/${TOTAL_BATCHES}..."

            WS_CMD="+force_install_dir ${PZ_INSTALL_DIR} +login anonymous"
            for ((j=i; j<i+BATCH_SIZE && j<TOTAL; j++)); do
                WS_CMD="${WS_CMD} +workshop_download_item 108600 ${WS_ARRAY[$j]}"
            done
            WS_CMD="${WS_CMD} +quit"

            steamcmd ${WS_CMD} || echo "[!] Aviso: Alguns downloads falharam no lote ${BATCH_NUM}"
        done

        # Auto-resolver Mod IDs a partir dos mod.info baixados
        echo "[*] Resolvendo Mod IDs dos arquivos mod.info..."
        MOD_IDS=""
        if [ -d "${WORKSHOP_DIR}" ]; then
            while IFS= read -r mod_info_file; do
                mod_id=$(grep -i "^id=" "$mod_info_file" 2>/dev/null | head -1 | cut -d'=' -f2 | tr -d '[:space:]' | tr -d '\r')
                if [ -n "$mod_id" ]; then
                    [ -n "$MOD_IDS" ] && MOD_IDS="${MOD_IDS};"
                    MOD_IDS="${MOD_IDS}${mod_id}"
                fi
            done < <(find "${WORKSHOP_DIR}" -name "mod.info" 2>/dev/null)
        fi

        RESOLVED_COUNT=$(echo "${MOD_IDS}" | tr ';' '\n' | grep -c '.' 2>/dev/null || echo "0")
        echo "[*] Resolvidos ${RESOLVED_COUNT} Mod IDs"

        # Atualizar arquivo .ini do servidor
        if [ ! -f "${SERVER_INI}" ]; then
            echo "[*] Criando ${SERVER_INI} com configuração de mods..."
            touch "${SERVER_INI}"
        fi

        # Atualizar WorkshopItems
        if grep -q "^WorkshopItems=" "${SERVER_INI}" 2>/dev/null; then
            sed -i "s|^WorkshopItems=.*|WorkshopItems=${WORKSHOP_IDS}|" "${SERVER_INI}"
        else
            echo "WorkshopItems=${WORKSHOP_IDS}" >> "${SERVER_INI}"
        fi

        # Atualizar Mods
        if [ -n "${MOD_IDS}" ]; then
            if grep -q "^Mods=" "${SERVER_INI}" 2>/dev/null; then
                sed -i "s|^Mods=.*|Mods=${MOD_IDS}|" "${SERVER_INI}"
            else
                echo "Mods=${MOD_IDS}" >> "${SERVER_INI}"
            fi
        fi

        echo "[*] Mods configurados com sucesso!"
    fi
else
    echo "[*] Arquivo workshop.txt não encontrado, iniciando sem mods da Workshop."
fi

# --- Verificar se o start-server.sh existe ---
if [ ! -f "${PZ_INSTALL_DIR}/start-server.sh" ]; then
    echo "[ERRO] start-server.sh não encontrado em ${PZ_INSTALL_DIR}"
    echo "[ERRO] A instalação do SteamCMD pode ter falhado."
    ls -la "${PZ_INSTALL_DIR}/" 2>/dev/null || echo "[ERRO] Diretório não existe."
    exit 1
fi

chmod +x "${PZ_INSTALL_DIR}/start-server.sh"

# --- Iniciar servidor ---
echo "[*] Iniciando servidor: ${PZ_SERVER_NAME}"
echo "[*] RAM: ${PZ_JAVA_XMS} - ${PZ_JAVA_XMX}"
echo "[*] Admin: ${PZ_ADMIN_USERNAME}"
echo "============================================"

cd "${PZ_INSTALL_DIR}"

exec ./start-server.sh \
    -Xms${PZ_JAVA_XMS} -Xmx${PZ_JAVA_XMX} \
    -- \
    -adminusername "${PZ_ADMIN_USERNAME}" \
    -adminpassword "${PZ_ADMIN_PASSWORD}" \
    -servername "${PZ_SERVER_NAME}" \
    -steamvac "${PZ_STEAM_VAC}"
