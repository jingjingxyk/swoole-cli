#!/bin/sh

export DOCKER_BUILDKIT=1

TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="alpine-edge-"${TIME}
IMAGE="jingjingxyk/build-swoole-cli-dev-dependencies:${VERSION}"



# 使用代理下载源码
# sh build-dependencies.sh --proxy 1
PROXY_URL=${2:+'http://192.168.3.26:8015'}


#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile-All-Dependencies  . --progress=plain --build-arg PROXY_URL=$PROXY_URL
# docker push ${IMAGE}
echo ${IMAGE} > build-dev-2-container.txt
exit
