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
cd ${WORK_TEMP_DIR}/privoxy/

autoheader
autoconf

./configure \
  --prefix=/usr/ \
  --with-openssl \
  --without-mbedtls \
  --with-brotli \
  --with-docbook=no
