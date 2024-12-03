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
cd ${__PROJECT__}/socat

make -j $(nproc)

SOCAT_VERSION=$(./socat -V | grep 'socat version' | awk '{ print $3 }')
echo ${SOCAT_VERSION} > ${__PROJECT__}/socat.version
strip ./socat
