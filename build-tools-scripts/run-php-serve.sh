#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)

cd ${__DIR__}
mkdir -p ${__DIR__}/dist/

cd ${__DIR__}/dist/

xdg-open http://127.0.0.1:8032

#test -f ./swoole-cli && chmod a+x ./swoole-cli && ./swoole-cli ./serve.php
test -f ./swoole-cli && chmod a+x ./swoole-cli && ./swoole-cli -S 0.0.0.0:8032 -t .

