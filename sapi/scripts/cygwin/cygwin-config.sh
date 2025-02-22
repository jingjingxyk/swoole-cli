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
cd ${__PROJECT__}/socat

# libtoolize -ci
# autoreconf -fi
autoconf


<<<<<<< HEAD
./configure --help

CFLAGS=" -O2 -Wall -fPIC  -DWITH_OPENSSL" \
  ./configure \
  --prefix=/usr \
  --enable-readline \
  --enable-openssl-base=/usr
=======
mkdir -p ${__PROJECT__}/bin/

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
cd ${WORK_TEMP_DIR}/php-src/

# export CPPFLAGS="-I/usr/include"
# export CFLAGS="-DZEND_WIN32=1 -DPHP_WIN32=1 -DWIN32 "
# https://github.com/php/php-src/blob/php-8.1.27/win32/build/confutils.js#L3227
# export LDFLAGS="-L/usr/lib"

./buildconf --force
test -f Makefile && make clean
./configure --prefix=/usr --disable-all \
  \
  --disable-fiber-asm \
  --without-pcre-jit \
  --with-openssl --enable-openssl \
  --with-curl \
  --with-iconv \
  --enable-intl \
  --with-bz2 \
  --enable-bcmath \
  --enable-filter \
  --enable-session \
  --enable-tokenizer \
  --enable-mbstring \
  --enable-ctype \
  --with-zlib \
  --enable-posix \
  --enable-sockets \
  --enable-pdo \
  --with-sqlite3 \
  --enable-phar \
  --enable-pcntl \
  --enable-mysqlnd \
  --with-mysqli \
  --enable-fileinfo \
  --with-pdo_mysql \
  --enable-soap \
  --with-xsl \
  --with-gmp \
  --enable-exif \
  --with-sodium \
  --enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml \
  --enable-gd --with-jpeg --with-freetype \
  --enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares \
  --enable-swoole-pgsql \
  --enable-swoole-sqlite \
  --enable-redis \
  --enable-opcache \
  --disable-opcache-jit \
  --with-imagick \
  --with-yaml \
  --with-readline \
  ${OPTIONS}

#  --with-pdo-pgsql \
#  --with-pgsql
#  --with-pdo-sqlite \
#  --with-zip   #  cygwin libzip-devel 版本库暂不支持函数 zip_encryption_method_supported （2020年新增函数)
# --enable-zts
# --disable-opcache-jit
>>>>>>> new_dev
