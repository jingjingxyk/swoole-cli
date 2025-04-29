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

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
cd ${WORK_TEMP_DIR}/socat/

make -j $(nproc)

APP_VERSION=$(./socat -V | grep 'socat version' | awk '{ print $3 }')
echo ${APP_VERSION} >${__PROJECT__}/APP_VERSION
echo 'socat' >${__PROJECT__}/APP_NAME

strip ./socat
