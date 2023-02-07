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
  docker stop swoole-cli-build-dev-1
  docker rm swoole-cli-build-dev-1
} || {
  echo $?
}
cd ${__DIR__}
default_image=docker.io/jingjingxyk/build-swoole-cli:build-dev-1-alpine-edge-20230207T100244Z

test -f swoole-cli-build-dev-1-container.txt && image=$(cat swoole-cli-build-dev-1-container.txt)
test -f swoole-cli-build-dev-1-container.txt || image=docker.io/jingjingxyk/build-swoole-cli:build-dev-1-alpine-edge-20230207T100244Z


cd ${__DIR__}
docker run --rm --name swoole-cli-build-dev-1 -d -v ${__PROJECT__}:/work -w /work $image tail -f /dev/null

