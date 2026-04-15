#!/bin/bash
set -e

PZ_INSTALL_DIR="/home/pzuser/pzserver"
PZ_CONFIG_DIR="/home/pzuser/Zomboid"

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
