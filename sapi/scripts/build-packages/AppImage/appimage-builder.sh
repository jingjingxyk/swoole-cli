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

pip3 install appimage-builder
appimage-builder --generate
appimagetool AppDir
