#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}
cd ${__DIR__}/php-versions

curl -Lo php-8.1.12.tar.gz https://www.php.net/distributions/php-8.1.12.tar.gz
tar -zxvf php-8.1.12.tar.gz


curl -Lo xz-5.2.9.tar.gz https://tukaani.org/xz/xz-5.2.9.tar.gz
