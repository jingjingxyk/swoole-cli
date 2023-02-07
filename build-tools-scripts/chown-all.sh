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


cd ${__PROJECT__}

chown -R 1000:1000 .

cd ${__DIR__}
