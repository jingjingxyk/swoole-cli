#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
'Linux')
  OS="linux"
  ;;
'Darwin')
  OS="darwin"
  ;;
*)
  case $OS in
  'MSYS_NT'* | 'CYGWIN_NT'*)
    OS="windows"
    ;;
  'MINGW64_NT'*)
    OS="windows"
    ;;
  *)
    echo '暂未配置的 OS '
    exit 0
    ;;
  esac
  ;;
esac

case $ARCH in
'x86_64')
  ARCH="amd64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

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
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com,goproxy.cn"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

APP_VERSION='v1.959.0'
APP_NAME='casdoor'
VERSION='v1.959.0'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}
if [[ ! -f ${__PROJECT__}/runtime/node/bin/node ]]; then
  if [[ "$MIRROR" == "china" ]]; then
    curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china
  else
    curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-nodejs-runtime.sh?raw=ture | bash
  fi
fi
if [[ ! -f ${__PROJECT__}/runtime/go/bin/go ]]; then
  if [[ "$MIRROR" == "china" ]]; then
    curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-go-runtime.sh?raw=ture | bash -s -- --mirror china
  else
    curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-go-runtime.sh?raw=ture | bash
  fi
fi

export PATH="${__PROJECT__}/runtime/go/bin/:${__PROJECT__}/runtime/node/bin/:$PATH"
export GO111MODULE=on
export GOPATH=~/go
export GOSUMDB=sum.golang.org
export GOROOT=${__PROJECT__}/runtime/go/
export GOBIN=${__PROJECT__}/runtime/go/bin/
# unset GOPROXY
# unset GOSUMDB
export GOPROXY="https://goproxy.cn,direct"

go version
echo $GOPATH
echo $GOBIN

mkdir -p ${__PROJECT__}/var/runtime/${APP_NAME}/
cd ${__PROJECT__}/var/runtime/${APP_NAME}/
APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ -d casdoor ]; then
  cd casdoor
  git pull
else
  git clone https://github.com/casdoor/casdoor.git
fi

cd ${__PROJECT__}/var/runtime/${APP_NAME}/casdoor/web/
ls -lh ~/.npm/
ls -lh ~/.npm/_logs/
pwd

npm install -g yarn craco pnpm --registry=https://registry.npmmirror.com
yarn install --yes --registry https://registry.npmmirror.com

yarn build
# yarn start

cd ${__PROJECT__}/var/runtime/${APP_NAME}/casdoor/
go build

# deploy
cd ${__PROJECT__}/var/runtime/${APP_NAME}/casdoor/
# run  casdooor
# ./casdoor

test -d ${APP_RUNTIME_DIR}/swagger/ && rm -rf ${APP_RUNTIME_DIR}/swagger/
test -d ${APP_RUNTIME_DIR}/web/build/ && rm -rf && rm -rf ${APP_RUNTIME_DIR}/web/

mkdir -p ${APP_RUNTIME_DIR}/swagger/
mkdir -p ${APP_RUNTIME_DIR}/conf/
mkdir -p ${APP_RUNTIME_DIR}/web/build/

chmod a+x ./casdoor
cp -f ./casdoor ${APP_RUNTIME_DIR}/
cp -rf ./swagger/. ${APP_RUNTIME_DIR}/swagger/
test -f ${APP_RUNTIME_DIR}/conf/app.conf || cp -f ./conf/app.conf ${APP_RUNTIME_DIR}/conf/app.conf
cp -rf ./web/build/. ${APP_RUNTIME_DIR}/web/build/

ls -lh ${APP_RUNTIME_DIR}/
cd ${APP_RUNTIME_DIR}/
# run  casdooor
# ./casdoor

${APP_RUNTIME_DIR}/casdoor -h

cat >${APP_RUNTIME_DIR}/start.sh <<'EOF'
#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

./casdoor

EOF

# doc
# https://casdoor.org/zh/docs/basic/server-installation/

# edit conf/app.conf

# driverName = sqlite
# dataSourceName = file:casdoor.db?cache=shared
# dbName = casdoor
