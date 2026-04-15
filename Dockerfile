FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências + SteamCMD
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        locales \
        steamcmd \
        lib32gcc-s1 \
        libsdl2-2.0-0:i386 \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# Variáveis do servidor
ENV PZ_SERVER_NAME="PZServer"
ENV PZ_ADMIN_USERNAME="admin"
ENV PZ_ADMIN_PASSWORD="changeme"
ENV PZ_JAVA_XMS="4g"
ENV PZ_JAVA_XMX="8g"
ENV PZ_STEAM_VAC="true"
ENV PZ_BETA_BRANCH=""

# Criar usuário não-root e diretórios com ownership correto
RUN useradd -m -s /bin/bash pzuser \
    && mkdir -p /home/pzuser/pzserver /home/pzuser/Zomboid \
    && chown -R pzuser:pzuser /home/pzuser
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /home/pzuser
USER pzuser

# Inicializar SteamCMD
RUN steamcmd +quit

EXPOSE 16261/udp
EXPOSE 16262/udp
EXPOSE 27015/tcp

CMD ["/usr/local/bin/entrypoint.sh"]
