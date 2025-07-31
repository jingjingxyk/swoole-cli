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

VERSION=1.17

download() {
  # document https://www.gnu.org/software/libiconv/

  curl -fSLo ${__PROJECT__}/pool/lib/libiconv-${VERSION}.tar.gz https://ftpmirror.gnu.org/gnu/libiconv/libiconv-${VERSION}.tar.gz
}

build() {

  cd ${WORK_TEMP_DIR}
  tar xvf ${__PROJECT__}/pool/lib/libiconv-${VERSION}.tar.gz

  cd libiconv-${VERSION}
  mkdir -p build
  cd build
  ../configure \
    --prefix=/usr \
    --enable-extra-encodings

  make -j $(nproc)
  make install

}

cd ${__PROJECT__}
test -f ${__PROJECT__}/pool/lib/libiconv-${VERSION}.tar.gz || download

build
