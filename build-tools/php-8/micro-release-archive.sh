#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}



mkdir -p release/
cd release

ls -lh ${__DIR__}/build/php-src/sapi/micro/micro.sfx
cp -rf ${__DIR__}/build/php-src/sapi/micro/micro.sfx .


test -f micro.sfx.zip && rm -f micro.sfx.zip

zip  -r  ./micro.sfx.zip ./micro.sfx
chown -R 1000:1000 .
