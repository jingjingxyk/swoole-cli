#!/bin/sh

export DOCKER_BUILDKIT=1
TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="alpine-edge-"${TIME}
IMAGE="jingjingxyk/build-swoole-cli:${VERSION}"


# sh build-docker.sh --proxy 1
PROXY_URL=${2:+'http://192.168.3.26:8015'}


#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile  . --progress=plain --build-arg PROXY_URL=$PROXY_URL

echo ${IMAGE} > build-base-container.txt

# docker push ${IMAGE}

exit 0
