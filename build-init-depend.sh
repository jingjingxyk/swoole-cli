#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

PROXY_URL=${2:+'http://127.0.0.1:8015'}

if test -n $PROXY_URL
then
  export http_proxy=http://192.168.3.26:8015
  export https_proxy=http://192.168.3.26:8015
fi


pear config-set http_proxy $http_proxy

# SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
php prepare.php  +inotify

chmod a+x ./make.sh
