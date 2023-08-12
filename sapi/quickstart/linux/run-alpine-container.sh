#!/bin/bash

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
IMAGE=alpine:3.17


ARCH=$(uname -m)

IMAGE=docker.io/jingjingxyk/build-swoole-cli:native-php-all-dependencies-alpine-php-7.4-${ARCH}-20230504T124927Z

TAG="all-dependencies-alpine-swoole-cli-x86_64-20230505T120137Z"
TAG="native-php-all-dependencies-alpine-php-7.4-${ARCH}-20230504T124927Z"

IMAGE="docker.io/jingjingxyk/build-swoole-cli:${TAG}"
ALIYUN_IMAGE="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:build-swoole-cli-${TAG}"

cd ${__DIR__}
docker run --rm --name swoole-cli-alpine-dev -d -v ${__PROJECT__}:/work -w /work $IMAGE tail -f /dev/null
