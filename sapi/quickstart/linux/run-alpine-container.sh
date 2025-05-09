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

IMAGE=alpine:3.18

MIRROR=''
DEV_SHM=0

while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    case "$MIRROR" in
    china | openatom)
      IMAGE="docker.io/library/alpine:3.18"
      ;;
    esac
    ;;
  --dev-shm) #使用 /dev/shm 目录加快构建速度
    DEV_SHM=1
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

cd ${__DIR__}

if [ $DEV_SHM -eq 1 ]; then
  mkdir -p /dev/shm/swoole-cli/thirdparty/
  mkdir -p /dev/shm/swoole-cli/ext/
  docker run --rm --name swoole-cli-alpine-dev -d -v ${__PROJECT__}:/work -v /dev/shm/swoole-cli/thirdparty/:/work/thirdparty/ -v /dev/shm/swoole-cli/ext/:/work/ext/ -w /work --init $IMAGE tail -f /dev/null
else
  docker run --rm --name swoole-cli-alpine-dev -d -v ${__PROJECT__}:/work -w /work --init $IMAGE tail -f /dev/null

fi
