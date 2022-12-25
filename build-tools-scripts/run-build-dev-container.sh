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
  docker stop build-dev-dependencies
  docker rm build-dev-dependencies
} || {
  echo $?
}


cd ${__DIR__}
test -f build-dev-dependencies-container.txt && image=$(cat build-dev-dependencies-container.txt)
test -f build-dev-dependencies-container.txt || image=docker.io/jingjingxyk/build-swoole-cli:build-dev-all-dependencies-alpine-edge-20221225T180725Z
cd ${__DIR__}


docker run --rm --name  build-dev-dependencies -d -v ${__PROJECT__}:/work -w /work $image tail -f /dev/null


exit 0

rsync -avr --delete-before --stats --progress ${__PROJECT__}/ ${__PROJECT__}/build-tools/dist/ \
  --exclude ${__PROJECT__}/build-tools/dist \
  --exclude ${__PROJECT__}/Dockerfile-old \
  --exclude ${__PROJECT__}/Dockerfile \
  --exclude ${__PROJECT__}/README.md \
  --exclude ${__PROJECT__}/.github \
  --exclude ${__PROJECT__}/.idea

