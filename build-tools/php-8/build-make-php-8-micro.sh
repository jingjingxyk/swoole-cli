#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)


cd ${__DIR__}
cd ${__DIR__}/build/php-src/

# -L/usr/libmcrypt/lib
make    EXTRA_LDFLAGS_PROGRAM='-all-static   -L/usr/openssl/lib -L/usr/libiconv/lib -L/usr/libxml2/lib -L/usr/libxslt/lib -L/usr/brotli/lib -L/usr/cares/lib -L/usr/gmp/lib -L/usr/ncurses/lib -L/usr/readline/lib -L/usr/libyaml/lib -L/usr/libsodium/lib -L/usr/bzip2/lib -L/usr/zlib/lib -L/usr/liblz4/lib -L/usr/liblzma/lib -L/usr/libzstd/lib -L/usr/libzip/lib -L/usr/sqlite3/lib -L/usr/icu/lib -L/usr/oniguruma/lib -L/usr/mimalloc/lib -lmimalloc -L/usr/libjpeg/lib64 -L/usr/libgif/lib -L/usr/libpng/lib -L/usr/libwebp/lib -lwebpdemux -lwebpmux -L/usr/freetype/lib -L/usr/imagemagick/lib -L/usr/libidn2/lib -L/usr/curl/lib -L/usr/pgsql/lib -L/usr/libffi/lib -L/usr/libmcrypt/lib'  -j  $(nproc)


make  install-cli
#make  micro
# 编译 imagick 过程中，会主动下载 此库 https://github.com/nikic/PHP-Parser.git
# 如果一直下载不下来，请添加代理
# 详见截图： 截图 2023-02-26 17-02-40.png


