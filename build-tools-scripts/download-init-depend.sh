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

git config --global --add safe.directory '*'
git submodule update --init --recursive


# SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
# php prepare.php  +mongodb +inotify
php prepare.php +inotify  -imagick -gd -intl -posix -mysqli -soap -exif  -opcache -pcntl

chmod a+x ./make.sh

