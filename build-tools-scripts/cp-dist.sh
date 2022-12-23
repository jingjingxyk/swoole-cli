#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}
mkdir -p ${__DIR__}/dist/

cp /tmp/php/bin/php   ${__DIR__}/dist/
cp /tmp/php/bin/php-config   ${__DIR__}/dist/

