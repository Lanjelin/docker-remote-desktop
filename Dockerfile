FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

LABEL maintainer="lanjelin"

ENV TITLE=Docker-Remote-Desktop
ENV NOM_VERSION=8.9.1
	
RUN \
  mkdir -p /app && \
  echo "**** install remmina ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      remmina \
      remmina-plugin-exec \
      remmina-plugin-kiosk \
      remmina-plugin-kwallet \
      remmina-plugin-rdp \
      remmina-plugin-secret \
      remmina-plugin-spice \
      remmina-plugin-vnc \
      remmina-plugin-www \
      remmina-plugin-x2go \
      gnome-icon-theme* \
      tint2 \
      wget && \
  echo "**** install parsec ****" && \
    wget -q https://builds.parsec.app/package/parsec-linux.deb -O /app/parsec-linux.deb && \
    apt install /app/parsec-linux.deb  && \
  echo "**** install nomachine ****" && \
    wget -q https://download.nomachine.com/download/${NOM_VERSION%.*}/Linux/nomachine_${NOM_VERSION}_1_x86_64.tar.gz -O /app/nomachine.tar.gz && \
    cd /app && \
    tar -xf nomachine.tar.gz && \
    /app/NX/nxserver --install && \
    echo "EnableClipboard both" >> /app/NX/etc/server.cfg && \
  echo "**** cleanup ****" && \
    sed -i 's|</applications>|  <application title="Docker Remote Desktop" type="normal">\n    <maximized>no</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
    rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /app/nomachine.tar.gz \
      /app/parsec-linux.deb

COPY /root /

EXPOSE 3000 3001

VOLUME /config
