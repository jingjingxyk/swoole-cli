#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

__ROOT__=$(
  cd ${__DIR__}/../
  pwd
)

{
  docker stop swoole-cli-build-dev-download-ext-libs
  docker rm swoole-cli-build-dev-download-ext-libs
} || {
  echo $?
}


image=docker.io/jingjingxyk/build-swoole-cli:download-ext-libs-alpine-edge-20221223T062602Z

docker run --rm --name swoole-cli-build-dev-download-ext-libs -d -v ${__ROOT__}:/work -w /work $image tail -f /dev/null

