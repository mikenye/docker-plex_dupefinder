FROM alpine:3.11

ENV PUID=1000 \
    PGID=1000 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_ARG0=/usr/local/bin/plex_dupefinder

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN set -x && \
    echo "========== Installing prerequisites ==========" && \
    apk add --no-cache \
        file \
        python3 \
        py3-pip \
        git \
        gnupg && \
    python3 -m pip install --no-cache-dir --upgrade pip && \
    echo "========== Installing plex_dupefinder ==========" && \
    git clone --depth=1 https://github.com/l3uddz/plex_dupefinder /opt/plex_dupefinder && \
    ln -s /opt/plex_dupefinder/plex_dupefinder.py /usr/local/bin/plex_dupefinder && \
    cd /opt/plex_dupefinder && \
    mkdir -p /config && \
    echo "========== Save version info ==========" && \
    git log && \
    git log | head -1 && \
    git log | head -1 | tr -s " " "_" && \
    git log | head -1 | tr -s " " "_" > /VERSION && \
    echo "========== Installing more prerequisites ==========" && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --no-cache-dir --upgrade plexapi && \
    echo "========== Installing s6-overlay ==========" && \
    wget -q -O - https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
    echo "========== Clean-up ==========" && \
    apk del file git gnupg && \
    rm -rf /opt/plex_dupefinder/.git /opt/plex_dupefinder/.github /opt/plex_dupefinder/.gitignore /tmp/*

ENTRYPOINT [ "/init" ]
