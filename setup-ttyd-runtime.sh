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
  OS="macos"
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
  ARCH="x64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='1.7.7'
APP_NAME='ttyd'
VERSION='v1.2.0'

mkdir -p runtime
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}/
SSHD_CONFIG=${APP_RUNTIME_DIR}/etc/sshd_config

mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-ttyd/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"
CACERT_DOWNLOAD_URL="https://curl.se/ca/cacert.pem"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-ttyd/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-msys2-${ARCH}.zip"
fi

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
  --version)
    VERSION="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china)
  APP_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"
  if [ $OS = 'windows' ]; then
    APP_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/${APP_NAME}-${APP_VERSION}-msys2-${ARCH}.zip"
  fi
  CACERT_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/cacert.pem"
  ;;

esac

test -f cacert.pem || curl -LSo cacert.pem ${CACERT_DOWNLOAD_URL}

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    APP_RUNTIME="${APP_NAME}-${APP_VERSION}-msys2-${ARCH}"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.xz || curl -LSo ${APP_RUNTIME}.tar.xz ${APP_DOWNLOAD_URL}
  test -f ${APP_RUNTIME}.tar || xz -d -k ${APP_RUNTIME}.tar.xz
  test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
  test -d ${APP_NAME}/ && rm -rf ${APP_NAME}/
  mkdir -p ${APP_NAME}/
  tar -xvf ${APP_RUNTIME}.tar -C ${APP_NAME}/

  mkdir -p ${__PROJECT__}/runtime/${APP_NAME}
  test -d ${__PROJECT__}/runtime/${APP_NAME} && rm -rf ${__PROJECT__}/runtime/${APP_NAME}
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}
fi

cd ${__PROJECT__}/var/runtime

cp -f ${__PROJECT__}/var/runtime/cacert.pem ${__PROJECT__}/runtime/cacert.pem

cd ${__PROJECT__}/

tee ${APP_RUNTIME_DIR}/start.sh <<'EOF'
#!/usr/bin/env bash
set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}/

${__DIR__}/ttyd --writable -t enableSixel=true -t enableZmodem=true -t enableTrzsz=true -t rendererType=canvas --ipv6  -p 8080 bash

EOF

set +x

echo " "
echo " USE ttyd :"
echo " "
echo " ./runtime/ttyd/ttyd --writable -t enableSixel=true -t enableZmodem=true -t enableTrzsz=true -t rendererType=canvas  -p 8080 bash "
echo " "
echo " startup ttyd "
echo " "
echo " bash ./runtime/ttyd/start.sh"
echo " "
export PATH="${APP_RUNTIME_DIR}/bin/:${APP_RUNTIME_DIR}/sbin/:$PATH"
./runtime/ttyd/ttyd -v
