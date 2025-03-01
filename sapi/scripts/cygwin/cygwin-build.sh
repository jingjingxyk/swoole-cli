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
cd ${WORK_TEMP_DIR}/openssh/

make -j $(nproc)

make install
