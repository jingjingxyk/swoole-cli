#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/
test -d fossflow && rm -rf fossflow
git clone https://github.com/stan-smith/FossFLOW.git fossflow
cd fossflow

if [[ ! -f ${__PROJECT__}/runtime/node/bin/node ]]; then
  if [[ "$MIRROR" == "china" ]]; then
    curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china
  else
    curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-nodejs-runtime.sh?raw=ture | bash
  fi
fi

export PATH="${__PROJECT__}/runtime/node/bin/:$PATH"

npm install -g pnpm --registry=https://registry.npmmirror.com
pnpm install --registry=https://registry.npmmirror.com
# pnpm start
pnpm run build

mkdir -p ${__PROJECT__}/runtime/fossflow
cp -rf build/. ${__PROJECT__}/runtime/fossflow
cd ${__PROJECT__}
# fossflos docs
# https://github.com/stan-smith/FossFLOW
