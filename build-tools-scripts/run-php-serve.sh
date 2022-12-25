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

chown -R 1000:1000 .

test -f ./swoole-cli && chmod a+x ./swoole-cli && ./swoole-cli ./serve.php
test -f ./swoole-cli && chmod a+x ./swoole-cli && ./swoole-cli -S 0.0.0.0:7010 -t .

