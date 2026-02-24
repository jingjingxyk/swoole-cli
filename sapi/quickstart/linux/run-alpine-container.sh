#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__DIR__}

{
  docker stop swoole-cli-alpine-dev
  sleep 5
} || {
  echo $?
}
cd ${__DIR__}

IMAGE="alpine:3.23"
PLATFORM='linux/amd64'
DEV_SHM=0

ARCH=$(uname -m)
case $ARCH in
'x86_64')
  PLATFORM='linux/amd64'
  ;;
'aarch64')
  PLATFORM='linux/arm64'
  ;;
'riscv64')
  PLATFORM="linux/riscv64"
  ;;
'loongarch64')
  PLATFORM="linux/loongarch64"
  PLATFORM="linux/loong64"
  IMAGE="ghcr.io/loong64/alpine:3.23"
  ;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
  --platform)
    PLATFORM="$2"
    ;;
  --container-image)
    IMAGE="$2"
    ;;
  --dev-shm) #使用 /dev/shm 目录加快构建速度
    DEV_SHM=1
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

cd ${__DIR__}
if [ $DEV_SHM -eq 1 ]; then
  mkdir -p /dev/shm/swoole-cli/thirdparty/
  mkdir -p /dev/shm/swoole-cli/ext/
  docker run --rm --name swoole-cli-alpine-dev --platform ${PLATFORM} -d -v ${__PROJECT__}:/work -v /dev/shm/swoole-cli/thirdparty/:/work/thirdparty/ -v /dev/shm/swoole-cli/ext/:/work/ext/ -w /work --init $IMAGE tail -f /dev/null
else
  docker run --rm --name swoole-cli-alpine-dev --platform ${PLATFORM} -d -v ${__PROJECT__}:/work -w /work --init $IMAGE tail -f /dev/null
fi

# bash sapi/quickstart/linux/run-alpine-container.sh --platform "linux/loong64" --container-image "ghcr.io/loong64/alpine:3.23"
