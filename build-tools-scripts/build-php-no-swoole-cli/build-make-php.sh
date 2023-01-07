#!/bin/bash

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
cd ${__DIR__}/php-src/


make    EXTRA_LDFLAGS_PROGRAM='-all-static   -L/usr/libiconv/lib -L/usr/openssl/lib -L/usr/libxml2/lib -L/usr/libxslt/lib -L/usr/gmp/lib -L/usr/zlib/lib -L/usr/bzip2/lib -L/usr/sqlite3/lib -L/usr/oniguruma/lib -L/usr/brotli/lib -L/usr/lib -L/usr/curl/lib -L/usr/libsodium/lib  -L/usr/mimalloc/lib '  -j  $(nproc)


make install

/tmp/php/bin/php -v

