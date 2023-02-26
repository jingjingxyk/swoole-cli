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

mkdir -p source-code
cd ${__DIR__}/source-code

proxy_url='http://192.168.3.26:8015'
export http_proxy=$proxy_url
export https_proxy=$proxy_url


test -d swoole-cli-source-code || git clone -b new_dev_build --depth=1 --progress --recursive https://github.com/jingjingxyk/swoole-cli.git swoole-cli-source-code
test -d swoole-cli-source-code && git -C swoole-cli-source-code pull --rebase=true --depth=1 --allow-unrelated-histories

# git submodule update --init --recursive