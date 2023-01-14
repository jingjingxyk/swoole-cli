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


cd ${__PROJECT__}



ls -lh ${__PROJECT__}/bin/swoole-cli
# 禁用移除符号表信息
# strip ${__PROJECT__}/bin/swoole-cli
ls -lh ${__PROJECT__}/bin/swoole-cli

${__PROJECT__}/bin/swoole-cli -v

mkdir -p ${__DIR__}/dist/
cp -rf ${__PROJECT__}/bin/swoole-cli ${__DIR__}/dist/
