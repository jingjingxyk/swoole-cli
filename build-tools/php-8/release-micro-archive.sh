#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


ls -lh ${__DIR__}/build/php-src/sapi/micro/micro.sfx
cp -rf ${__DIR__}/build/php-src/sapi/micro/micro.sfx ${__DIR__}/micro/micro.sfx


cd ${__DIR__}/micro/
test -f micro.sfx.zip && rm -f micro.sfx.zip

zip  -r  ./micro.sfx.linux.zip ./micro.sfx

cd ${__DIR__}
chown -R 1000:1000 .
