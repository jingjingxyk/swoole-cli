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
mkdir -p pool/lib/
WORK_TEMP_DIR=${__PROJECT__}/var/msys2-build/
mkdir -p ${WORK_TEMP_DIR}

VERSION=libucontext-1.3.2

download() {
  # document https://github.com/kaniini/libucontext

  curl -fSLo ${__PROJECT__}/pool/lib/${VERSION}.tar.gz https://github.com/kaniini/libucontext/archive/refs/tags/${VERSION}.tar.gz
}

build() {

  cd ${WORK_TEMP_DIR}
  mkdir -p ${WORK_TEMP_DIR}/libucontext
  tar --strip-components=1 -C ${WORK_TEMP_DIR}/libucontext -xf ${__PROJECT__}/pool/lib/${VERSION}.tar.gz


  cd ${WORK_TEMP_DIR}/libucontext
  make -j $(nproc) ARCH=$(uname -m)
  make ARCH=$(uname -m)  check
  make ARCH=$(uname -m)  DESTDIR=/usr/ install

}

cd ${__PROJECT__}
test -f ${__PROJECT__}/pool/lib/${VERSION}.tar.gz || download

build
