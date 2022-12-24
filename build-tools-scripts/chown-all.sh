#!/bin/bash

set -exu

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

__ROOT__=$(
  cd ${__DIR__}/../
  pwd
)


cd ${__ROOT__}

chown -R 1000:1000 .

cd ${__DIR__}
