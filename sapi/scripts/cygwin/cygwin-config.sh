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

OPTIONS=''
OPTIONS+=' --enable-swoole-thread '
OPTIONS+=' --enable-brotli '
OPTIONS+=' --enable-zstd '
OPTIONS+=' --enable-zts '
OPTIONS+=' --disable-opcache-jit '

X_PHP_VERSION=''
while [ $# -gt 0 ]; do
  case "$1" in
  --php-version)
    PHP_VERSION="$2"
    X_PHP_VERSION=$(echo ${PHP_VERSION:0:3})
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p ${__PROJECT__}/bin/

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
cd ${WORK_TEMP_DIR}/php-src/

# export CFLAGS=""
# export CPPFLAGS="-I/tmp/swoole-cli/libiconv/include"
# export LDFLAGS="-L/tmp/swoole-cli/libiconv/lib"
# export LIBS="  -liconv "
export ICU_CXXFLAGS=" -std=gnu++17 "
./buildconf --force
test -f Makefile && make clean
./configure --prefix=/usr --disable-all \
  \
  --disable-fiber-asm \
  --without-pcre-jit \
  --with-iconv


#  --with-pdo-pgsql \
#  --with-pgsql
#  --with-pdo-sqlite \
#  --with-zip   #  cygwin libzip-devel 版本库暂不支持函数 zip_encryption_method_supported （2020年新增函数)
# --enable-zts
# --disable-opcache-jit
