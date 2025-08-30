FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=DOGWALK

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/dogwalk-logo.png && \
  mkdir -p \
    /usr/share/icons/hicolor/192x192/apps/ && \
  cp \
    /usr/share/selkies/www/icon.png \
    /usr/share/icons/hicolor/192x192/apps/dogwalk.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    pcmanfm \
    unzip && \
  curl -o \
    /tmp/dogwalk.zip -L \
    "https://studio.blender.org/download-source/files/3f/d3/3fd3ee7fc72a17913271ce5e43a2decd-38.zip" && \
  cd /tmp && \
  unzip dogwalk.zip && \
  mv \
    dogwalk-linux* \
    /opt/dogwalk-linux && \
  echo "**** app wrapper ****" && \
  echo "#! /bin/bash" > /opt/dogwalk-linux/run.sh && \
  echo "rm -Rf /config/.local/share/godot" >> /opt/dogwalk-linux/run.sh && \
  echo "/opt/dogwalk-linux/dogwalk.x86_64" >> /opt/dogwalk-linux/run.sh && \
  chmod +x /opt/dogwalk-linux/run.sh && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
