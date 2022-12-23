#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__ROOT__=$(
  cd ${__DIR__}/../
  pwd
)

cd ${__ROOT__}
ls -lh .

ls -lh  ${__ROOT__}/bin/

cd ${__ROOT__}/bin/
test -f ./swoole-cli && chmod a+x ./swoole-cli && ./swoole-cli  -r 'phpinfo();'

