#!/bin/sh

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

export DOCKER_BUILDKIT=1

TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="build-dev-download-library-and-extension-alpine-edge-"${TIME}
IMAGE="docker.io/jingjingxyk/build-swoole-cli:${VERSION}"




# 使用代理下载源码
# sh build-dependencies.sh --proxy 1
PROXY_URL=${2:+'http://192.168.3.26:8015'}


cd ${__DIR__}

#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile-alpine-download-library-and-extension  . --progress=plain --build-arg PROXY_URL=$PROXY_URL

echo ${IMAGE} > build-dev-download-library-and-extension-container.txt
docker push ${IMAGE}

exit
