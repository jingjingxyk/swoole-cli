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
  docker stop swoole-cli-build-dev
  docker rm swoole-cli-build-dev
} || {
  echo $?
}

sudo chown -R 1000:1000 ${__ROOT__}
image=$(cat base-container-image.txt)
docker run --rm --name swoole-cli-build-dev -d -v ${__ROOT__}:/work -w /work $image tail -f /dev/null


exit 0


test -d ${__ROOT__}/build-tools/dist/ && sudo rm -rf ${__ROOT__}/build-tools/dist/
mkdir -p ${__ROOT__}/build-tools/dist/

rsync -avr --delete-before --stats --progress ${__ROOT__}/ ${__ROOT__}/build-tools/dist/ \
  --exclude ${__ROOT__}/build-tools/dist \
  --exclude ${__ROOT__}/Dockerfile-old \
  --exclude ${__ROOT__}/Dockerfile \
  --exclude ${__ROOT__}/README.md \
  --exclude ${__ROOT__}/.github \
  --exclude ${__ROOT__}/.idea

# docker run --rm --name swoole-cli-build-dev -v ${__DIR__}/dist:/work -w /work -ti --init  docker.io/jingjingxyk/build-swoole-cli:alpine-edge-20221205T144525Z

{
  docker stop swoole-cli-build-dev
  docker rm swoole-cli-build-dev
} || {
  echo $?
}

image=$(cat base-container-image.txt)
docker run --rm --name swoole-cli-build-dev -d -v ${__DIR__}/dist:/work -w /work $image tail -f /dev/null
