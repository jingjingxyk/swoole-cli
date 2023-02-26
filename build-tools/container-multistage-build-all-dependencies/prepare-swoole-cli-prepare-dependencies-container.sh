#!/bin/sh

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

export DOCKER_BUILDKIT=1

TIME=$(date -u '+%Y%m%dT%H%M%SZ')
VERSION="prepare-dependencies-alpine-edge-"${TIME}
IMAGE="docker.io/jingjingxyk/build-swoole-cli:${VERSION}"

cd ${__DIR__}

#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile-prepare-dependencies-source-code . --progress=plain

cd ${__DIR__}
echo ${IMAGE} >swoole-cli-prepare-dependencies-source-code-container.txt

aliyun_image=registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:build-swoole-cli-${VERSION}
docker tag $IMAGE $aliyun_image

docker push ${IMAGE}
docker push ${aliyun_image}
