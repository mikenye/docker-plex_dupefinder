FROM debian:stable-slim

ENV PUID=1000 \
    PGID=1000 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_ARG0=/usr/local/bin/plex_dupefinder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PACKAGES+=(ca-certificates) && \
    KEPT_PACKAGES+=(python3) && \
    KEPT_PACKAGES+=(python3-pip) && \
    KEPT_PACKAGES+=(python3-setuptools) && \
    KEPT_PACKAGES+=(python3-wheel) && \
    TEMP_PACKAGES+=(curl) && \
    TEMP_PACKAGES+=(file) && \
    TEMP_PACKAGES+=(gnupg) && \
    TEMP_PACKAGES+=(git) && \
    # Install packages.
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ${KEPT_PACKAGES[@]} \
        ${TEMP_PACKAGES[@]} \
        && \
    git config --global advice.detachedHead false && \
    python3 -m pip install --upgrade pip && \
    # Installing plex_dupefinder
    git clone --depth=1 https://github.com/l3uddz/plex_dupefinder /opt/plex_dupefinder && \
    ln -s /opt/plex_dupefinder/plex_dupefinder.py /usr/local/bin/plex_dupefinder && \
    pushd /opt/plex_dupefinder && \
    mkdir -p /config && \
    # Save version info
    git log | head -1 | tr -s " " "_" | tee /VERSION && \
    # Installing more prerequisites
    python3 -m pip install -r requirements.txt && \
    #python3 -m pip install --upgrade plexapi && \
    python3 -m pip install git+https://github.com/pkkid/python-plexapi.git && \
    # Installing s6-overlay
    curl --location -o /tmp/deploy-s6-overlay.sh https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh && \
    bash /tmp/deploy-s6-overlay.sh && \
    # Clean-up
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/* && \
    rm -rf /opt/plex_dupefinder/.git /opt/plex_dupefinder/.github /opt/plex_dupefinder/.gitignore

COPY etc/ /etc/

ENTRYPOINT [ "/init" ]
