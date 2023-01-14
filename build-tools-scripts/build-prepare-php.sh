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

sh make.sh cares
# sh make.sh icu_2
sh make.sh pgsql



