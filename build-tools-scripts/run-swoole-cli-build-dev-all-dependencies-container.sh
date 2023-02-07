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
test -f swoole-cli-build-dev-all-dependencies-container.txt && image=$(cat swoole-cli-build-dev-all-dependencies-container.txt)
test -f swoole-cli-build-dev-all-dependencies-container.txt || image=docker.io/jingjingxyk/build-swoole-cli:build-dev-all-dependencies-alpine-edge-20230107T091604Z
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

