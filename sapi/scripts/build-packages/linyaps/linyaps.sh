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
mkdir com.swoole.swoole-cli
touch com.swoole.swoole-cli/linglong.yaml

ll-builder build

# ll-builder run com.swoole.swoole-cli
ll-cli install com.swoole.swoole-cli
