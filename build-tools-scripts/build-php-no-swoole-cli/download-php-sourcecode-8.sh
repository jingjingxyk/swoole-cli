#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


export http_proxy=http://192.168.3.26:8015
export https_proxy=http://192.168.3.26:8015

version="php-8.2.2"
echo $version > version.txt

# test -d php-src || git clone -b $version --depth=1 https://github.com/php/php-src.git

test -f php-8.2.2.tar.gz || wget -O php-8.2.2.tar.gz https://github.com/php/php-src/archive/refs/tags/php-8.2.2.tar.gz

# test -d swoole-src  || git clone -b v5.0.1 --depth=1  https://github.com/swoole/swoole-src.git

test -f redis-5.3.7.tgz || wget -O redis-5.3.7.tgz https://pecl.php.net/get/redis-5.3.7.tgz
test -f mongodb-1.15.0.tgz || wget -O mongodb-1.15.0.tgz https://pecl.php.net/get/mongodb-1.15.0.tgz
test -f yaml-2.2.2.tgz || wget -O yaml-2.2.2.tgz https://pecl.php.net/get/yaml-2.2.2.tgz
test -f apcu-5.1.22.tgz || wget -O apcu-5.1.22.tgz https://pecl.php.net/get/apcu-5.1.22.tgz
test -f swoole-5.0.1.tgz || wget -O swoole-5.0.1.tgz https://pecl.php.net/get/swoole-5.0.1.tgz
test -f swoole-v5.0.2.tar.gz || wget -O swoole-v5.0.2.tar.gz https://github.com/swoole/swoole-src/archive/refs/tags/v5.0.2.tar.gz




exit 0

# https://www.php.net/distributions/php-8.2.0.tar.gz

# 下载重试
curl --connect-timeout 15 --retry 5 --retry-delay 5 -Lo php-8.1.12.tar.gz https://www.php.net/distributions/php-8.1.12.tar.gz







