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



export DOCKER_BUILDKIT=1

TIME=`date -u '+%Y%m%dT%H%M%SZ'`

:<<'EOF'
TIME=`date -u '+%Y%m%dT%H%M%SZ'`
VERSION="build-dev-1-alpine-edge-"${TIME}
IMAGE="docker.io/phpswoole/swoole_cli_os:${VERSION}"
EOF

VERSION="build-dev-1-alpine-edge-"${TIME}
IMAGE="docker.io/jingjingxyk/build-swoole-cli:${VERSION}"



cd ${__DIR__}
docker build -t ${IMAGE} -f ./Dockerfile-alpine-dev-1  . --progress=plain

cd ${__DIR__}
echo ${IMAGE} > swoole-cli-build-dev-1-container.txt


docker push ${IMAGE}

