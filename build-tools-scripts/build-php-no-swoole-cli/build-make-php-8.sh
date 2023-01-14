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

# make clean
make     EXTRA_LDFLAGS_PROGRAM='/usr/libiconv/lib/pkgconfig:/usr/openssl/lib64/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/liblz4/lib/pkgconfig:/usr/zip/lib/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/libjpeg/lib64/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/c-ares/lib/pkgconfig:/usr/imagemagick/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:/usr/pgsql/lib/pkgconfig'   -j  $(nproc)





make install

exit 0
/tmp/php/bin/php -v

ls -lh /tmp/php/bin/php
strip /tmp/php/bin/php
ls -lh /tmp/php/bin/php

