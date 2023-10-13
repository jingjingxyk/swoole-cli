#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

if [ -f ${__DIR__}/prepare.php ] ; then
  __PROJECT__=$(
    cd ${__DIR__}/
    pwd
  )
else
  __PROJECT__=$(
    cd ${__DIR__}/../../
    pwd
  )
fi

cd ${__PROJECT__}


# shellcheck disable=SC2034
OS=$(uname -s)
# shellcheck disable=SC2034
ARCH=$(uname -m)

case $OS in
'Linux')
  OS="linux"
  ;;
'Darwin')
  OS="macos"
  ;;
*)
  echo '暂未配置的 OS '
  exit 0
  ;;

esac

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    shift
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done


if [ $OS = 'linux' ] ; then
    if [ -f /.dockerenv ]; then
        number=$(which meson  | wc -l)
        if test $number -eq 0 ;then
        {
            if [ "$MIRROR" = 'china' ] ; then
                sh sapi/quickstart/linux/alpine-init.sh --mirror china
            else
                sh sapi/quickstart/linux/alpine-init.sh
            fi
        }
        fi
        git config --global --add safe.directory ${__PROJECT__}
    fi
fi

if [ $OS = 'macos' ] ; then
  number=$(which meson  | wc -l)
  if test $number -eq 0 ;then
  {
        if [ "$MIRROR" = 'china' ] ; then
            bash sapi/quickstart/macos/homebrew-init.sh --mirror china
        else
            bash sapi/quickstart/macos/homebrew-init.sh
        fi
  }
  fi
fi


if [ ! -f "${__PROJECT__}/bin/runtime/php" ] ;then
      if [ "$MIRROR" = 'china' ] ; then
          bash sapi/quickstart/setup-php-runtime.sh --mirror china
      else
          bash sapi/quickstart/setup-php-runtime.sh
      fi
fi

bash sapi/quickstart/clean-folder.sh

export PATH="${__PROJECT__}/bin/runtime:$PATH"
alias php="php -d curl.cainfo=${__PROJECT__}/bin/runtime/cacert.pem -d openssl.cafile=${__PROJECT__}/bin/runtime/cacert.pem"

php -v

export COMPOSER_ALLOW_SUPERUSER=1
# composer config -g repos.packagist composer https://packagist.org
# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
if [ "$MIRROR" = 'china' ]; then
    composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/
fi
composer update  --optimize-autoloader
composer config -g --unset repos.packagist

# 可用配置参数
# --with-swoole-pgsql=1
# --with-global-prefix=/usr/local/swoole-cli
# --with-dependency-graph=1
# --with-web-ui
# --with-build-type=dev
# --with-skip-download=1
# --with-http-proxy=http://192.168.3.26:8015
# --conf-path="./conf.d.extra"
# --without-docker=1
# @macos
# --with-override-default-enabled-ext=1
# --with-php-version=8.1.20
# --with-c-compiler=[gcc|clang] 默认clang



# bash sapi/quickstart/mark-install-library-cached.sh


php prepare.php \
  --without-docker=1 \
  --with-global-prefix=/usr/local/swoole-cli \
  +inotify +apcu +ds +xlswriter +ssh2 +pgsql -pdo_pgsql \
  --with-swoole-pgsql=1 --with-libavif=1

exit 0


bash make-install-deps.sh

bash make.sh all-library

bash make.sh config

bash make.sh build

