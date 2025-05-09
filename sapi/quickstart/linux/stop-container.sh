#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

{
  docker stop swoole-cli-alpine-dev
  docker stop swoole-cli-debian-dev
  docker stop swoole-cli-rhel-dev
  docker stop swoole-cli-ubuntu-dev
  docker stop swoole-cli-builder
  sleep 5
} || {
  echo $?
}
