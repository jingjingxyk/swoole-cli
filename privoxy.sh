#!/usr/bin/env bash

set -exu
__CURRENT__=`pwd`
__DIR__=$(cd "$(dirname "$0")";pwd)
__PROJECT__=${__DIR__}

cd ${__PROJECT__}

bash bin/runtime/privoxy/privoxy-start.sh
