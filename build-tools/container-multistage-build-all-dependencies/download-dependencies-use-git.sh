#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

# proxy_url='http://192.168.3.26:8015'
# export http_proxy=$proxy_url
# export https_proxy=$proxy_url

mkdir -p /source-code/git-download

cd ${__DIR__}/source-code/git-download


test -d quiche || git clone --recursive  --depth=1 https://github.com/cloudflare/quiche

test -d boringssl || git clone --depth=1  https://boringssl.googlesource.com/boringssl

test -d msh3 || git clone -b v0.6.0 --depth 1 --recursive https://github.com/nibanks/msh3

test -d libelf || git clone -b master --depth 1 --recursive https://github.com/WolfgangSt/libelf.git

cd ${__DIR__}


# # git submodule update --init
