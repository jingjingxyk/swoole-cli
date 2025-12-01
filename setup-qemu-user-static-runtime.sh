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
  'MSYS_NT'*)
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

APP_VERSION='v7.2.0-1'
APP_NAME='qemu-user-static'
VERSION='v7.2.0-1'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

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

cd ${__PROJECT__}/var/runtime

# download  https://github.com/multiarch/qemu-user-static/releases
# https://github.com/qemu/qemu/blob/master/scripts/qemu-binfmt-conf.sh
#  参考文档
#  https://www.cnblogs.com/eaglexmw/p/18432747
#  https://github.com/jingjingxyk/qemu-user-static.git
#  https://www.qemu.org/download/
#  https://gitlab.com/qemu-project/qemu.git

APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/${VERSION}/qemu-aarch64-static"
APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-aarch64-static.tar.gz"

APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-loongarch64-static"
APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-loongarch64-static.tar.gz"

APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-riscv64-static"
APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-riscv64-static.tar.gz"

APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-x86_64-static"
APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-x86_64-static.tar.gz"

APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/x86_64_qemu-riscv64-static.tar.gz"
APP_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-riscv64-static.tar.gz"

test -f qemu-riscv64-static.tar.gz || curl -LSo qemu-riscv64-static.tar.gz ${APP_DOWNLOAD_URL}
tar -xvf qemu-riscv64-static.tar.gz
cd ${__PROJECT__}/var/runtime

exit 0

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

# test -f ${APP_RUNTIME}.tar.xz || curl -LSo ${APP_RUNTIME}.tar.xz ${APP_DOWNLOAD_URL}
test -f x86_64_qemu-riscv64-static.tar.gz || curl -LSo x86_64_qemu-riscv64-static.tar.gz ${APP_DOWNLOAD_URL}
tar -xvf x86_64_qemu-riscv64-static.tar.gz
cd ${__PROJECT__}/var/runtime

cd ${__PROJECT__}/
