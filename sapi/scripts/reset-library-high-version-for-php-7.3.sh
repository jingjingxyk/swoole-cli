#!/usr/biin/env bash
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

:<<'EOF'
  本脚本的作用，充分利用已经编译好依赖库环境
  比如 php-8.2 已经编译好的 依赖库，用来编译 php-7.3 ，只需要重新编译如下几个依赖库即可

EOF

test -d thirdparty/openssl && rm -rf thirdparty/openssl
test -d thirdparty/libssh2 && rm -rf thirdparty/libssh2
test -d thirdparty/libzip  && rm -rf thirdparty/libzip
test -d thirdparty/curl    && rm -rf thirdparty/curl
test -d thirdparty/icu    && rm -rf thirdparty/icu
test -d thirdparty/php_src && rm -rf thirdparty/php_src

ln -s /usr/include/locale.h /usr/include/xlocale.h

sh make.sh openssl
sh make.sh libssh2
sh make.sh libzip
sh make.sh curl
sh make.sh icu
sh make.sh php_src

