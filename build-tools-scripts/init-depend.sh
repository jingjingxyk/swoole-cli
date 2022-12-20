#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}
cd ${__DIR__}/../

# SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
php prepare.php  +mongodb +inotify

chmod a+x ./make.sh

