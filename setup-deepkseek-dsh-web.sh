#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

UDPATE_DEEPSEEK_HARNESS=0
while [ $# -gt 0 ]; do
  case "$1" in
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
  --update-deepseek-harness)
    UDPATE_DEEPSEEK_HARNESS=1
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

if [[ ! -f ${__PROJECT__}/X_DEEPSEEK_HARNESS ]]; then
  test -d deepseek-harness || git clone https://github.com/deepseek-ai/deepseek-harness.git
  cd deepseek-harness
  echo 'deepseek-harness' >X_DEEPSEEK_HARNESS
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >>X_DEEPSEEK_HARNESS
else
  # 已经位于 deepseek-harness 源码目录
  echo "now: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
fi

if [ "$UDPATE_DEEPSEEK_HARNESS" -eq "1" ]; then
  git pull
  echo 'deepseek-harness' >X_DEEPSEEK_HARNESS
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >>X_DEEPSEEK_HARNESS
fi

if [[ ! -f ${__PROJECT__}/runtime/node/bin/node ]]; then
  if [[ "$MIRROR" == "china" ]]; then
    curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china
  else
    curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-nodejs-runtime.sh?raw=ture | bash
  fi
fi
export PATH="${__PROJECT__}/runtime/node/bin/:$PATH"


corepack --version # 输出版本号
corepack enable pnpm
# corepack use pnpm@latest


export ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"
export ELECTRON_BUILDER_BINARIES_MIRROR="https://npmmirror.com"
export SASS_BINARY_SITE="https://npmmirror.com"
export PUPPETEER_DOWNLOAD_HOST="https://npmmirror.com"
export CHROMEDRIVER_CDNURL="https://npmmirror.com/chromedriver"
export PYTHON_MIRROR="https://npmmirror.com/python"
export PROFILER_BINARY_HOST_MIRROR="https://npmmirror.com/node-inspector/"
export SQLITE3_BINARY_SITE="https://npmmirror.com/sqlite3"

pnpm install --registry=https://registry.npmmirror.com

# pnpm store prune --force


# curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-deepkseek-dsh-web.sh?raw=ture | bash -s -- --mirror china

unset http_proxy
unset https_proxy

cd ${__PROJECT__}
