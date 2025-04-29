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
WORK_TEMP_DIR=${__PROJECT__}/var/msys2-build/
cd ${WORK_TEMP_DIR}/socat/

# libtoolize -ci
# autoreconf -fi
autoconf

./configure --help

CFLAGS=" -O2 -Wall -fPIC  -DWITH_OPENSSL" \
  ./configure \
  --prefix=/usr \
  --enable-readline \
  --enable-openssl-base=/usr
