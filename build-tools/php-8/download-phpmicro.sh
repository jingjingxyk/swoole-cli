#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


# 使用代理
# export http_proxy=http://192.168.3.26:8015
# export https_proxy=http://192.168.3.26:8015


mkdir -p download
cd download

test -d phpmicro || git clone --depth=1 --progress  https://github.com/easysoft/phpmicro.git
test -d phpmicro && git -C phpmicro pull --rebase=true --depth=1 --allow-unrelated-histories
cd ${__DIR__}





