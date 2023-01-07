#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


export http_proxy=http://192.168.3.26:8015
export https_proxy=http://192.168.3.26:8015


test -d php-src || git clone -b PHP-7.4.33 --depth=1 https://github.com/php/php-src.git



exit 0
# 下载重试
curl --connect-timeout 15 --retry 5 --retry-delay 5 -Lo php-8.1.12.tar.gz https://www.php.net/distributions/php-8.1.12.tar.gz

# https://www.php.net/distributions/php-8.2.0.tar.gz

test -d php-8.1.12 && rm -rf php-8.1.12
test -f php-8.1.12.tar.gz && rm -rf php-8.1.12.tar.gz




