#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}

mkdir -p source-code
cd ${__DIR__}/source-code

test -f swoole-cli-v5.0.2-linux-x64.tar.xz || curl -LO https://wenda-1252906962.file.myqcloud.com/dist/swoole-cli-v5.0.2-linux-x64.tar.xz
test -f swoole-cli-v5.0.2-linux-x64.tar ||  xz -d -k swoole-cli-v5.0.2-linux-x64.tar.xz
test -f swoole-cli ||  tar -xvf swoole-cli-v5.0.2-linux-x64.tar

chmod a+x swoole-cli

test -f composer.phar || curl -LO https://mirrors.aliyun.com/composer/composer.phar

