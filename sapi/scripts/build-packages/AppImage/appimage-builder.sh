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
sudo pip3 install uv
uv venv
source .venv/bin/activate

pip3 install appimage-builder
mkdir -p AppDir/usr/bin
# 将你的可执行文件复制到 AppDir/usr/bin/

# ~/.local/bin/appimage-builder

appimage-builder --generate
appimagetool AppDir
