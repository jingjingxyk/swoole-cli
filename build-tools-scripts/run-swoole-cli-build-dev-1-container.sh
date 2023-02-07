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
  docker stop swoole-cli-build-dev-1
  docker rm swoole-cli-build-dev-1
} || {
  echo $?
}

if test $(ls ${__PROJECT__}/pool | wc -l) -eq 0
then
  container_id=$(docker create jingjingxyk/build-swoole-cli:build-dev-download-library-and-extension-alpine-edge-20230107T090322Z)  # returns container ID
  docker cp $container_id:/swoole-cli/pool/lib ${__PROJECT__}/pool
  docker cp $container_id:/swoole-cli/pool/ext ${__PROJECT__}/pool
  docker rm $container_id
fi


test -f swoole-cli-build-dev-1-container.txt && image=$(cat swoole-cli-build-dev-1-container.txt)
test -f swoole-cli-build-dev-1-container.txt || image=docker.io/jingjingxyk/build-swoole-cli:build-dev-1-alpine-edge-20230107T093432Z

cd ${__DIR__}

docker run --rm --name swoole-cli-build-dev-1 -d -v ${__PROJECT__}:/work -w /work $image tail -f /dev/null

