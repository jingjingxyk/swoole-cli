#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

export http_proxy=http://192.168.3.26:8015
export https_proxy=http://192.168.3.26:8015

php prepare.php +inotify +mongodb
#chmod a+x ./make.sh
