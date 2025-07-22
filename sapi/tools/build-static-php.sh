#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)

cd ${__DIR__}
cd ${__PROJECT__}

mkdir -p var/
cd ${__PROJECT__}/var/

PHP_VERSION=8.2.29

test -f php-${PHP_VERSION}.tar.gz || curl -fSLo php-${PHP_VERSION}.tar.gz https://github.com/php/php-src/archive/refs/tags/php-${PHP_VERSION}.tar.gz
test -d php-src && rm -rf php-src
mkdir -p php-src
tar --strip-components=1 -C php-src -xf php-${PHP_VERSION}.tar.gz

export CC=clang
export CXX=clang++
export LD=ld.lld

if [[ $(uname -m) == 'loongarch64' ]]; then
  # for fiber
  export LIBS=" -lucontext "
  bash sapi/scripts/install-libucontext.sh
fi
cd php-src

bash ${__DIR__}/opcache-static-compile-patch.sh

./buildconf --force

./configure \
  --disable-all \
  --disable-cgi \
  --enable-shared=no \
  --enable-static=yes \
  --enable-cli \
  --enable-zts \
  --disable-phpdbg \
  --without-valgrind \
  --enable-opcache \
  --without-pcre-jit

export LDFLAGS=" -static -all-static "
sed -i.backup 's/-export-dynamic/-all-static/g' Makefile

make -j $(nproc)

file sapi/cli/php
readelf -h sapi/cli/php

sapi/cli/php -m
sapi/cli/php -v
