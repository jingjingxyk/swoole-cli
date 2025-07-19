#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

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
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

if [ ! -f "${__PROJECT__}/runtime/node/bin/node" ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china
fi
export PATH=${__PROJECT__}/runtime/node/bin/:$PATH

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/
if [ -f swoole-docs/.git/index ]; then
  cd swoole-docs/
  git pull
else
  # git clone -b dev --depth=1 https://github.com/swoole/docs.git swoole-docs
  git clone -b dev --depth=1 https://github.com/jingjingxyk/swoole-docs.git
fi
cd ${__PROJECT__}/var/swoole-docs/
npm install -g pnpm --registry=https://registry.npmmirror.com
pnpm install --registry=https://registry.npmmirror.com

# npx docsify --help

cd ${__PROJECT__}/var/swoole-docs/public
test -f _sidebar.md && rm -f _sidebar.md
npx docsify generate .

cat >robots.txt <<EOF
User-agent: *
Disallow:
EOF

if [ -f ${__PROJECT__}/tools/upload-swoole-docs.sh ]; then
  bash ${__PROJECT__}/tools/upload-swoole-docs.sh
fi

cd ${__PROJECT__}/var/swoole-docs/public
python3 -m http.server 4000
