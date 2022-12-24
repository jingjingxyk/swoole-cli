#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__ROOT__=$(
  cd ${__DIR__}/..
  pwd
)

cd ${__DIR__}
cd ${__DIR__}/php-versions/

test -d php-8-source-code && rm -rf php-8-source-code
mkdir -p php-8-source-code
tar -zxvf php-8.1.12.tar.gz  --strip-components 1 -C php-8-source-code

cd php-8-source-code

:<<EOF
cp -rf ${__ROOT__}/ext/redis ext
cp -rf ${__ROOT__}/ext/mongodb ext
cp -rf ${__ROOT__}/ext/yaml ext
cp -rf ${__ROOT__}/ext/swoole ext
EOF

PKG_CONFIG_PATH='/usr/lib/pkgconfig:/usr/lib64/pkgconfig'
export PKG_CONFIG_PATH="/usr/libxml2/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/openssl/lib64/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:$PKG_CONFIG_PATH"

./configure --prefix=/tmp/php \
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
--with-openssl=/usr/openssl

# --enable-intl  # use icu

cd ${__DIR__}
sh build-make-php.sh
