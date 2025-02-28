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
mkdir -p ${WORK_TEMP_DIR}/openssh

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
cd ${WORK_TEMP_DIR}/openssh/

autoreconf -fi
./configure --help
mkdir build
cd build
../configure \
  --prefix=/usr/ \
  --with-pie
