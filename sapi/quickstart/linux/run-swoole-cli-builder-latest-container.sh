#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__DIR__}

{
  docker stop swoole-cli-builder-latest
  sleep 5
} || {
  echo $?
}
cd ${__DIR__}

IMAGE=swoole-cli-builder:latest

cd ${__DIR__}
docker run --rm --name swoole-cli-builder-latest --platform "linux/loong64" -d -v ${__PROJECT__}:/work -w /work --init $IMAGE tail -f /dev/null
