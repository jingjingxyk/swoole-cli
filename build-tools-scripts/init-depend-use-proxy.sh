#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}
cd ${__DIR__}/../

export http_proxy=http://192.168.3.26:8015
export https_proxy=http://192.168.3.26:8015

pear config-set http_proxy $http_proxy
pecl config-show

# SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
# php prepare.php  +mongodb +inotify
php prepare.php

pear config-set http_proxy ''



chmod a+x ./make.sh

chown -R 1000:1000 .
