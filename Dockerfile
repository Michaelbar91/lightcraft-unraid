# syntax=docker/dockerfile:1
# LightCraft (native Linux-Version) im Browser, über Selkies gestreamt – inoffiziell, für Unraid.
# Wird per GitHub Actions gebaut und als ghcr.io/michaelbar91/lightcraft-unraid veröffentlicht.
# Lokal bauen: docker build --build-arg LIGHTCRAFT_VERSION=0.19.0 -t lightcraft-local .

FROM ghcr.io/linuxserver/baseimage-selkies:arch

ARG LIGHTCRAFT_VERSION=0.19.0

ENV TITLE=LightCraft \
    NO_GAMEPAD=true \
    PIXELFLUX_WAYLAND=true \
    LIGHTCRAFT_LIBRARY="/config/LightCraft Library"

RUN \
  echo "**** Laufzeitpakete ****" && \
  pacman -Sy --noconfirm --needed \
    vulkan-swrast \
    zenity && \
  echo "**** Version bestimmen ****" && \
  if [ "${LIGHTCRAFT_VERSION}" = "latest" ]; then \
    LIGHTCRAFT_VERSION="$(curl -fsSI https://github.com/storytold/lightcraft/releases/latest \
      | tr -d '\r' | sed -n 's#^[Ll]ocation: .*/tag/v\(.*\)$#\1#p')"; \
  fi && \
  test -n "${LIGHTCRAFT_VERSION}" && \
  echo "LightCraft ${LIGHTCRAFT_VERSION}" && \
  echo "**** LightCraft laden und prüfen ****" && \
  BASE="https://github.com/storytold/lightcraft/releases/download/v${LIGHTCRAFT_VERSION}" && \
  F="lightcraft-${LIGHTCRAFT_VERSION}-linux-x86_64.tar.gz" && \
  mkdir -p /tmp/dl /opt/lightcraft && cd /tmp/dl && \
  curl -fsSLO "${BASE}/SHA256SUMS.txt" && \
  curl -fsSLO "${BASE}/${F}" && \
  grep "  ${F}\$" SHA256SUMS.txt | sha256sum -c - && \
  tar -xzf "${F}" -C /opt/lightcraft --strip-components=1 && \
  test -x /opt/lightcraft/bin/lightcraft && \
  ln -sf /opt/lightcraft/bin/lightcraft /usr/bin/lightcraft && \
  ln -sf /opt/lightcraft/bin/lightcraft-cli /usr/bin/lightcraft-cli && \
  cp /opt/lightcraft/share/icons/hicolor/512x512/apps/ai.storyteller.lightcraft.png \
    /usr/share/selkies/www/icon.png && \
  echo "**** Aufräumen ****" && \
  rm -rf /tmp/* /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

COPY /root /

EXPOSE 3001
