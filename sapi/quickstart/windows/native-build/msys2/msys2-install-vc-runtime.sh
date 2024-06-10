#!/usr/bin/env bash
set -x

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../../../
  pwd
)
cd ${__PROJECT__}

start  "cmd"  " /c sapi\quickstart\windows\native-build\install-vc-runtime.bat"
start  "cmd"  " /c sapi\quickstart\windows\native-build\install-visualstudio-2019.bat"
start  "cmd"  " /c sapi\quickstart\windows\native-build\install-deps-soft.bat"

