#!/bin/sh

#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)


export DOCKER_BUILDKIT=1

TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="build-dependencies-alpine-edge-"${TIME}
IMAGE="docker.io/jingjingxyk/build-swoole-cli:${VERSION}"




# 使用代理下载源码
# sh build-dependencies.sh --proxy 1
PROXY_URL=${2:+'http://192.168.3.26:8015'}


cd ${__DIR__}

#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile-build-dependencies . --progress=plain --build-arg PROXY_URL=$PROXY_URL

cd ${__DIR__}
echo ${IMAGE} > swoole-cli-Dockerfile-build-dependencies-container.txt

aliyun_image=registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:build-swoole-cli-${VERSION}
docker tag $IMAGE $aliyun_image

echo ${aliyun_image} > swoole-cli-Dockerfile-build-dependencies-aliyun-container.txt

docker push ${IMAGE}
docker push ${aliyun_image}


