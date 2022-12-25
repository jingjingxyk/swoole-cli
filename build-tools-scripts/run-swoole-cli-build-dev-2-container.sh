#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)
cd ${__DIR__}


{
  docker stop swoole-cli-build-dev-2
  docker rm swoole-cli-build-dev-2
} || {
  echo $?
}


test -f swoole-cli-build-dev-2-container.txt && image=$(cat swoole-cli-build-dev-1-container.txt)
test -f swoole-cli-build-dev-2-container.txt || image=docker.io/jingjingxyk/build-swoole-cli:build-dev-2-alpine-edge-20221225T054827Z

cd ${__DIR__}


docker run --rm --name swoole-cli-build-dev-2 -d -v ${__PROJECT__}:/work -w /work $image tail -f /dev/null
