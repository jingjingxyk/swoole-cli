#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

test -d php-src   && rm -rf php-src
test -d swoole-src     && rm -rf  swoole-src

