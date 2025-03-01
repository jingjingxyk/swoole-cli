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
cd ${__PROJECT__}
mkdir -p bin

WORK_TEMP_DIR=${__PROJECT__}/var/msys2-build/
cd ${WORK_TEMP_DIR}/privoxy/

make -j $(nproc)

make install
