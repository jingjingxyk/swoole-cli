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



APP_VERSION='v3.0.3'
APP_NAME='immich'
VERSION='v3.0.3'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

mkdir -p ${__PROJECT__}/var/runtime/${APP_NAME}
cd ${__PROJECT__}/var/runtime/${APP_NAME}

DOCKER_COMPOSE_DOWNLOAD_URL="https://github.com/immich-app/immich/releases/download/${VERSION}/docker-compose.yml"
DOCKER_COMPOSE_ENV_DOWNLOAD_URL="https://github.com/immich-app/immich/releases/download/${VERSION}/example.env"


MIRROR=''
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

DOCKER_COMPOSE="docker-compose.yml"
DOCKER_COMPOSE_ENV=".env"


  test -f ${DOCKER_COMPOSE} || curl -LSo ${DOCKER_COMPOSE} ${DOCKER_COMPOSE_DOWNLOAD_URL}
  test -f ${DOCKER_COMPOSE_ENV} || curl -LSo ${DOCKER_COMPOSE_ENV} ${DOCKER_COMPOSE_ENV_DOWNLOAD_URL}
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}/


cd ${__PROJECT__}/

set +x

echo " "
echo " use immich :"
echo " "
echo " immich wiki :  https://immich.app/docs/overview/welcome "
echo " "
echo " immich install script : https://github.com/immich-app/immich/blob/main/install.sh"
echo " "
echo " cd ${__PROJECT__}/runtime/${APP_NAME}/"
echo " start: docker compose -f docker-compose.yml up -d "
echo " stop:  docker compose -f docker-compose.yml download --remove-orphans "
echo " "

if [ "$OS" != 'linux' ] ; then
  echo 'start immich only support linux !'
  exit 0
fi
