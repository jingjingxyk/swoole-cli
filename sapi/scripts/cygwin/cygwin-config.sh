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
WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
mkdir -p ${WORK_TEMP_DIR}
mkdir -p ${__PROJECT__}/bin/

cd ${WORK_TEMP_DIR}/socat/
# libtoolize -ci
# autoreconf -fi
autoconf
