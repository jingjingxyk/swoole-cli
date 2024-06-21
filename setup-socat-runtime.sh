#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}

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
  'MSYS_NT'* | 'CYGWIN_NT'* )
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
'aarch64' | 'arm64' )
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

SOCAT_VERSION='1.8.0.0'
VERSION='v2.1.0'

mkdir -p bin/runtime
mkdir -p var/runtime

cd ${__PROJECT__}/var/runtime

SOCAT_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-socat/releases/download/${VERSION}/socat-${SOCAT_VERSION}-${OS}-${ARCH}.tar.xz"
CACERT_DOWNLOAD_URL="https://curl.se/ca/cacert.pem"

if [ $OS = 'windows' ]; then
  SOCAT_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-socat/releases/download/${VERSION}/socat-${SOCAT_VERSION}-vs2022-${ARCH}.zip"
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
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china)
  SOCAT_DOWNLOAD_URL="https://php-cli.jingjingxyk/socat-${SOCAT_VERSION}-${OS}-${ARCH}.tar.xz"
  if [ $OS = 'windows' ]; then
    SOCAT_DOWNLOAD_URL="https://php-cli.jingjingxyk/socat-${SOCAT_VERSION}-vs2022-${ARCH}.zip"
  fi
  ;;

esac

test -f cacert.pem || curl -LSo cacert.pem ${CACERT_DOWNLOAD_URL}

SOCAT_RUNTIME="socat-${SOCAT_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    SOCAT_RUNTIME="socat-${SOCAT_VERSION}-vs2022-${ARCH}"
    test -f ${SOCAT_RUNTIME}.zip || curl -LSo ${SOCAT_RUNTIME}.zip ${SOCAT_DOWNLOAD_URL}
    test -d ${SOCAT_RUNTIME} && rm -rf ${SOCAT_RUNTIME}
    unzip "${SOCAT_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${SOCAT_RUNTIME}.tar.xz || curl -LSo ${SOCAT_RUNTIME}.tar.xz ${SOCAT_DOWNLOAD_URL}
  test -f ${SOCAT_RUNTIME}.tar || xz -d -k ${SOCAT_RUNTIME}.tar.xz
  test -f socat || tar -xvf ${SOCAT_RUNTIME}.tar
  chmod a+x socat
  cp -f ${__PROJECT__}/var/runtime/socat ${__PROJECT__}/bin/runtime/socat
fi

cd ${__PROJECT__}/var/runtime

cp -f ${__PROJECT__}/var/runtime/cacert.pem ${__PROJECT__}/bin/runtime/cacert.pem


cd ${__PROJECT__}/

set +x

echo " "
echo " USE SOCAT RUNTIME :"
echo " "
echo " export PATH=\"${__PROJECT__}/bin/runtime:\$PATH\" "
echo " "
echo " socat [options] <address> <address> "
echo " socat docs :  http://www.dest-unreach.org/socat/"
echo " socat example :  https://www.redhat.com/sysadmin/getting-started-socat"
echo " "
export PATH="${__PROJECT__}/bin/runtime:$PATH"
