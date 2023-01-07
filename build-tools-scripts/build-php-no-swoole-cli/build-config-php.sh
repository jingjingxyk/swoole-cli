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

version=PHP-7.4.33

cd ${__DIR__}/php-src/


PKG_CONFIG_PATH=''
test -d /usr/lib/pkgconfig && PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/lib64/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH"


export PKG_CONFIG_PATH=/usr/libiconv/lib/pkgconfig:/usr/openssl/lib/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/liblz4/lib/pkgconfig:/usr/liblzma/lib/pkgconfig:/usr/libzstd/lib/pkgconfig:/usr/zip/lib/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/libjpeg/lib64/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/imagemagick/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:$PKG_CONFIG_PATH

./buildconf --force ;

mkdir -p /tmp/${version}/php/

./configure --prefix=/tmp/php/ \
    --disable-all \
    --enable-ctype \
    --enable-fileinfo \
    --enable-filter \
    --with-iconv=/usr/libiconv \
    --enable-pdo \
    --with-pdo-sqlite \
    --enable-phar \
    --enable-posix \
    --enable-session \
    --with-sqlite3=/usr/sqlite3 \
    --enable-tokenizer \
    --enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml=/usr/libxml2 \
    --with-curl=/usr/curl \
    --with-bz2=/usr/bzip2 \
    --enable-bcmath \
    --enable-pcntl \
    --enable-tokenizer \
    --enable-mbstring \
    --with-zlib=/usr/zlib/ \
    --enable-sockets \
    --enable-mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-xsl=/usr/libxslt \
    --with-gmp=/usr/gmp \
    --with-sodium=/usr/libsodium \
    --with-readline \
    --with-openssl --with-openssl-dir=/usr/openssl \

#

# --enable-intl  # use icu

cd ${__DIR__}

