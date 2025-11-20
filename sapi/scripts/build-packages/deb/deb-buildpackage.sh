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
cd ${__PROJECT__}

dpkg -b swoole-cli swoole-cli_v6.1.1.0_amd64.deb
