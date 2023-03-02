#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

# 使用代理
# export http_proxy=http://192.168.3.26:8015
# export https_proxy=http://192.168.3.26:8015

version="php-7.0.21"
echo $version > version.txt


mkdir -p download
cd ${__DIR__}/download

# test -d php-src || git clone -b $version --depth=1 https://github.com/php/php-src.git

# https://github.com/php/php-src/archive/refs/tags/php-7.0.21.tar.gz

test -f $version.tar.gz || curl --retry 5 --retry-delay 5 -Lo $version.tar.gz  https://github.com/php/php-src/archive/refs/tags/$version.tar.gz

test -d swoole-src  || git clone -b v4.0.3 --depth=1  https://github.com/swoole/swoole-src.git
cd swoole-src
git submodule update --init

# wget -O swoole-4.8.12.tgz https://pecl.php.net/get/swoole-4.8.12.tgz

cd ${__DIR__}/download

test -f redis-5.3.7.tgz || curl --retry 5 --retry-delay 5 -Lo redis-5.3.7.tgz https://pecl.php.net/get/redis-5.3.7.tgz
test -f mongodb-1.6.0.tgz || curl --retry 5 --retry-delay 5 -Lo mongodb-1.6.0.tgz https://pecl.php.net/get/mongodb-1.6.0.tgz
test -f yaml-2.1.0.tgz || curl --retry 5 --retry-delay 5 -Lo yaml-2.1.0.tgz https://pecl.php.net/get/yaml-2.1.0.tgz
test -f apcu-5.1.22.tgz || curl --retry 5 --retry-delay 5 -Lo apcu-5.1.22.tgz https://pecl.php.net/get/apcu-5.1.22.tgz
test -f imagick-3.6.0.tgz || curl --retry 5 --retry-delay 5 -Lo imagick-3.6.0.tgz https://pecl.php.net/get/imagick-3.6.0.tgz
test -f ds-1.4.0.tgz || curl --retry 5 --retry-delay 5 -Lo ds-1.4.0.tgz https://pecl.php.net/get/ds-1.4.0.tgz
test -f inotify-3.0.0.tgz || curl --retry 5 --retry-delay 5 -Lo inotify-3.0.0.tgz https://pecl.php.net/get/inotify-3.0.0.tgz

cd ${__DIR__}

