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

version="php-8.2.3"
version="php-8.1.16"
echo $version > version.txt


mkdir -p download
cd download

# test -d php-src || git clone -b $version --depth=1 https://github.com/php/php-src.git

# test -f php-8.1.15.tar.gz || curl --retry 5 --retry-delay 5 -Lo php-8.1.15.tar.gz https://github.com/php/php-src/archive/refs/tags/php-8.1.15.tar.gz
test -f $version.tar.gz || curl --retry 5 --retry-delay 5 -Lo $version.tar.gz  https://github.com/php/php-src/archive/refs/tags/$version.tar.gz


# test -d swoole-src  || git clone -b v5.0.1 --depth=1  https://github.com/swoole/swoole-src.git

test -f redis-5.3.7.tgz || curl --retry 5 --retry-delay 5 -Lo redis-5.3.7.tgz https://pecl.php.net/get/redis-5.3.7.tgz
test -f mongodb-1.15.0.tgz || curl --retry 5 --retry-delay 5 -Lo mongodb-1.15.0.tgz https://pecl.php.net/get/mongodb-1.15.0.tgz
test -f yaml-2.2.2.tgz || curl --retry 5 --retry-delay 5 -Lo yaml-2.2.2.tgz https://pecl.php.net/get/yaml-2.2.2.tgz
test -f apcu-5.1.22.tgz || curl --retry 5 --retry-delay 5 -Lo apcu-5.1.22.tgz https://pecl.php.net/get/apcu-5.1.22.tgz
# test -f swoole-5.0.1.tgz || wget -O swoole-5.0.1.tgz https://pecl.php.net/get/swoole-5.0.1.tgz
test -f swoole-v5.0.2.tar.gz || curl --retry 5 --retry-delay 5 -Lo swoole-v5.0.2.tar.gz https://github.com/swoole/swoole-src/archive/refs/tags/v5.0.2.tar.gz

test -f imagick-3.6.0.tgz || curl --retry 5 --retry-delay 5 -Lo imagick-3.6.0.tgz https://pecl.php.net/get/imagick-3.6.0.tgz
test -f ds-1.4.0.tgz || curl --retry 5 --retry-delay 5 -Lo ds-1.4.0.tgz https://pecl.php.net/get/ds-1.4.0.tgz
test -f inotify-3.0.0.tgz || curl --retry 5 --retry-delay 5 -Lo inotify-3.0.0.tgz https://pecl.php.net/get/inotify-3.0.0.tgz

test -f mcrypt-1.0.5.tgz || curl --retry 5 --retry-delay 5 -Lo mcrypt-1.0.5.tgz https://pecl.php.net/get/mcrypt-1.0.5.tgz


cd ${__DIR__}





