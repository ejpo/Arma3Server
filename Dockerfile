FROM debian:buster-slim

LABEL maintainer="ejpo - github.com/ejpo"

RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        python3 \
        lib32stdc++6 \
        lib32gcc1 \
        wget \
        ca-certificates \
    && \
    apt-get remove --purge -y \
    && \
    apt-get clean autoclean \
    && \
    apt-get autoremove -y \
    && \
    rm /var/lib/apt/lists/* -r \
    && \
    adduser arma3 \
    && \
    mkdir -p /steamcmd \
        && cd /steamcmd \
        && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf - \
        && chown arma3:arma3 /steamcmd \
    && \
    mkdir /arma3 \
        && chown arma3:arma3 /arma3


ENV ARMA_BINARY=./arma3server \
    ARMA_CONFIG=main.cfg \
    ARMA_PROFILE=main \
    ARMA_WORLD=empty \
    HEADLESS_CLIENTS=0 \
    PORT=2302 \
    STEAM_BRANCH=public \
    STEAM_BRANCH_PASSWORD=

EXPOSE 2302/udp \
       2303/udp \
       2304/udp \
       2305/udp \
       2306/udp

ADD launch.py /launch.py

VOLUME /steamcmd

USER arma3

WORKDIR /arma3

STOPSIGNAL SIGINT

CMD ["python3","/launch.py"]
