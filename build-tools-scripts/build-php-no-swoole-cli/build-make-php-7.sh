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

export PATH=/usr/c-ares/bin/:/usr/pgsql/bin/:/usr/libffi/bin/:/usr/icu_2/bin/:$PATH

export CXXFLAGS=$(/usr/icu_2/bin/icu-config --cxxflags)
export LDFLAGS=$(icu-config --ldflags)

# make clean
make    EXTRA_LDFLAGS_PROGRAM='-all-static -fno-ident -L/usr/libiconv/lib -L/usr/openssl/lib -L/usr/libxml2/lib -L/usr/libxslt/lib -L/usr/gmp/lib -L/usr/zlib/lib -L/usr/bzip2/lib -L/usr/liblz4/lib -L/usr/liblzma/lib -L/usr/libzstd/lib -L/usr/zip/lib -L/usr/giflib/lib -L/usr/libpng/lib -L/usr/libjpeg/lib64 -L/usr/brotli/lib -L/usr/libwebp/lib -L/usr/freetype/lib/ -L/usr/sqlite3/lib -L/usr/oniguruma/lib -L/usr/imagemagick/lib -L/usr/curl/lib -L/usr/libsodium/lib -L/usr/libyaml/lib -L/usr/mimalloc/lib  -L/usr/icu/lib -L/usr/pgsql/lib/ -L/usr/lib/ -lstdc++'   -j  $(nproc)





make install

exit 0
/tmp/php/bin/php -v

ls -lh /tmp/php/bin/php
strip /tmp/php/bin/php
ls -lh /tmp/php/bin/php

