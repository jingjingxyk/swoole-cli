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
test -d php-src || git clone -b $version --depth=1 https://github.com/php/php-src.git

# test -d swoole-src  || git clone -b v5.0.1 --depth=1  https://github.com/swoole/swoole-src.git
test -d swoole-src  || git clone -b v4.8.11 --depth=1  https://github.com/swoole/swoole-src.git


exit 0

# https://www.php.net/distributions/php-8.2.0.tar.gz

# 下载重试
curl --connect-timeout 15 --retry 5 --retry-delay 5 -Lo php-8.1.12.tar.gz https://www.php.net/distributions/php-8.1.12.tar.gz







