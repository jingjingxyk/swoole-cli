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
cd ${__PROJECT__}/build-tools-scripts/php-versions/

test -d php-8-source-code && rm -rf php-8-source-code
mkdir -p php-8-source-code
tar -zxvf php-8.1.12.tar.gz  --strip-components 1 -C php-8-source-code

cd php-8-source-code


PKG_CONFIG_PATH=''
test -d /usr/lib/pkgconfig && PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/lib64/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH"


export PKG_CONFIG_PATH=/usr/openssl/lib64/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/bzip2/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:$PKG_CONFIG_PATH
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
    --enable-intl \
    --with-pdo-mysql=mysqlnd \
    --with-xsl=/usr/libxslt \
    --with-gmp=/usr/gmp \
    --with-sodium=/usr/libsodium \
    --with-openssl=/usr/openssl --with-openssl-dir=/usr/openssl \
    --with-readline=/usr/readline


# --enable-intl  # use icu

cd ${__DIR__}
sh build-make-php.sh
