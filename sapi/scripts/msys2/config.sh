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
mkdir -p ${WORK_TEMP_DIR}/openssh/build/

cd ${WORK_TEMP_DIR}/openssh/

autoreconf -fi
./configure --help

cd build
../configure \
--prefix=/usr/local/swoole-cli/openssh/ \
--with-libedit=/usr/ \
--with-zlib=/usr/ \
--with-ssl-dir=/usr/ \
--enable-year2038 \
--with-pie
