#!/bin/sh

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

export DOCKER_BUILDKIT=1
TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="alpine-edge-"${TIME}
IMAGE="jingjingxyk/build-swoole-cli:${VERSION}"
# IMAGE="phpswoole/swoole_cli_os:build-swoole-cli-${VERSION}"

cd ${__DIR__}/../

docker build -t ${IMAGE} -f ./Dockerfile  . --progress=plain


cd ${__DIR__}

echo ${IMAGE} > base-container-image.txt

# docker push ${IMAGE}

exit 0
