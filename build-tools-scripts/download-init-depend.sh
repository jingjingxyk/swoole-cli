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
cd ${__DIR__}
cd ${__PROJECT__}

# SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
# php prepare.php  +mongodb +inotify
php prepare.php

chmod a+x ./make.sh

