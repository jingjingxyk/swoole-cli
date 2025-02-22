#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-socat-runtime.sh | bash -s -- --mirror china

./bin/runtime/socat -d -d TCP4-LISTEN:8016,reuseaddr,fork ssl:http-proxy.xiaoshuogeng.com:8015,verify=1,\
snihost=http-proxy.xiaoshuogeng.com,commonname=http-proxy.xiaoshuogeng.com,\
openssl-min-proto-version=TLS1.3,openssl-max-proto-version=TLS1.3,cafile=./bin/runtime/cacert.pem
