#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)

cd ${__DIR__}
cd ${__PROJECT__}

sudo apt update && sudo apt install -y flatpak flatpak-builder
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub org.freedesktop.Platform//22.08 org.freedesktop.Sdk//22.08

flatpak-builder --init
flatpak-builder --user build-dir manifest.json
flatpak install build-dir/MyApp.flatpak
