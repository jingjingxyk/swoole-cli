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
  docker stop swoole-cli-build-dev-all-dependencies-container
  docker rm swoole-cli-build-dev-all-dependencies-container
} || {
  echo $?
}
cd ${__DIR__}
default_image=registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:build-swoole-cli-build-dependencies-alpine-edge-20230226T074232Z


# test -f swoole-cli-build-dev-all-dependencies-container.txt && image=$(cat container/swoole-cli-build-dev-all-dependencies-container.txt)
test -f swoole-cli-build-dev-all-dependencies-container.txt || image=$default_image

cd ${__DIR__}
docker run --rm --name  swoole-cli-build-dev-all-dependencies-container -d -v ${__PROJECT__}:/work -w /work $image tail -f /dev/null


exit 0

mkdir -p ${__PROJECT__}/build-tools/prepare-build/
rsync -avr --delete-before --stats --progress ${__PROJECT__}/ ${__PROJECT__}/build-tools/prepare-build/ \
  --exclude ${__PROJECT__}/.github \
  --exclude ${__PROJECT__}/.idea \
  --exclude ${__PROJECT__}/.git \
  --exclude ${__PROJECT__}/build-tools-scripts \
  --exclude ${__PROJECT__}/autom4te.cache \
  --exclude ${__PROJECT__}/include \
  --exclude ${__PROJECT__}/libs \
  --exclude ${__PROJECT__}/modules \
  --exclude ${__PROJECT__}/README.md \
  --exclude ${__PROJECT__}/Makefile.objects \
  --exclude ${__PROJECT__}/Makefile.fragments \
  --exclude ${__PROJECT__}/Makefile \
  --exclude ${__PROJECT__}/make.sh \
  --exclude ${__PROJECT__}/libtool \
  --exclude ${__PROJECT__}/configure \
  --exclude ${__PROJECT__}/config.status \
  --exclude ${__PROJECT__}/config.nice \
  --exclude ${__PROJECT__}/config.log \
  --exclude ${__PROJECT__}/config.status

