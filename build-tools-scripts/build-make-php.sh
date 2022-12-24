#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__ROOT__=$(
  cd ${__DIR__}/../
  pwd
)

cd ${__DIR__}
cd ${__DIR__}/php-versions/php-8-source-code


make     EXTRA_LDFLAGS_PROGRAM='-all-static -L/usr/libiconv/lib -L/usr/libxml2/lib -L/usr/sqlite3/lib -L/usr/gmp/lib -L/usr/bzip2/lib -L/usr/openssl/lib64 -L/usr/curl/lib  -L/usr/libxslt/lib -L/usr/oniguruma/lib -L/usr/libsodium/lib' -j  $(nproc)


make install

cd ${__DIR__}

mkdir -p ${__DIR__}/dist/

test -f /tmp/php/bin/php && cp -f /tmp/php/bin/php   ${__DIR__}/dist/
test -f /tmp/php/bin/php-config && cp -f /tmp/php/bin/php-config   ${__DIR__}/dist/
chown -R 1000:1000 ${__DIR__}/dist/
