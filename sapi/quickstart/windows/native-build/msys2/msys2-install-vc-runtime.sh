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

start /wait "cmd"  " /c sapi\quickstart\windows\native-build\install-vc-runtime.bat"
start /wait "cmd"  " /c sapi\quickstart\windows\native-build\install-visualstudio-2019.bat"
start /wait "cmd"  " /c sapi\quickstart\windows\native-build\install-deps-soft.bat"

