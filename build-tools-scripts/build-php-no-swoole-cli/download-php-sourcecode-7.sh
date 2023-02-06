#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


export http_proxy=http://192.168.3.26:8015
export https_proxy=http://192.168.3.26:8015

version="php-7.4.30"
echo $version > version.txt



# test -d php-src || git clone -b $version --depth=1 https://github.com/php/php-src.git

test -f php-7.4.33.tar.gz || wget https://github.com/php/php-src/archive/refs/tags/php-7.4.33.tar.gz

test -d swoole-src  || git clone -b 4.8.x --depth=1  https://github.com/swoole/swoole-src.git

# wget -O swoole-4.8.12.tgz https://pecl.php.net/get/swoole-4.8.12.tgz
test -f redis-5.3.7.tgz || wget -O redis-5.3.7.tgz https://pecl.php.net/get/redis-5.3.7.tgz
test -f mongodb-1.15.0.tgz || wget -O mongodb-1.15.0.tgz https://pecl.php.net/get/mongodb-1.15.0.tgz
test -f yaml-2.2.2.tgz || wget -O yaml-2.2.2.tgz https://pecl.php.net/get/yaml-2.2.2.tgz
test -f apcu-5.1.22.tgz || wget -O apcu-5.1.22.tgz https://pecl.php.net/get/apcu-5.1.22.tgz




