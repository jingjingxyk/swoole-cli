#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)
cd ${__PROJECT__}

OS=$(uname -s)
ARCH=$(uname -m)

export PATH=${__PROJECT__}/bin/runtime:$PATH
php -v

# composer config  repo.packagist composer https://mirrors.aliyun.com/composer/

composer update

# curl 不起用 nghttp2
#  -gd -zip -imagick 三个扩展编译不成功，需要更换依赖库

# macos
php prepare.php --with-build-type=release +apcu +ds @macos    -gd -zip -imagick

# linux
php prepare.php --with-build-type=release +apcu +ds   -gd -zip -imagick
