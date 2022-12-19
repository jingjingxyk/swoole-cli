#!/bin/sh

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

export DOCKER_BUILDKIT=1
TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="download-ext-libs-alpine-edge-"${TIME}
IMAGE="docker.io/jingjingxyk/build-swoole-cli:${VERSION}"


docker build -t ${IMAGE} -f ./Dockerfile-alpine  . --progress=plain

docker push ${IMAGE}


