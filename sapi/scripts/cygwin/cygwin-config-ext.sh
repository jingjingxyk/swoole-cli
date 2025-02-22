#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__PROJECT__}

SOCAT_VERSION='1.8.0.1'

while [ $# -gt 0 ]; do
  case "$1" in
  --socat-version)
    SOCAT_VERSION="$2"
    ;;
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;

  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

<<<<<<< HEAD
cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/pool/
mkdir -p ${__PROJECT__}/var/

# download socat source code
# https://repo.or.cz/socat.git

if [ ! -f ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz ]; then
  cd ${__PROJECT__}/var/
  test -d socat && rm -rf socat
  git clone -b tag-1.8.0.1 https://repo.or.cz/socat.git
  cd socat
  curl -Lo cacert.pem https://curl.se/ca/cacert.pem
  tar -czvf ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz .
  cd ${__PROJECT__}

  # curl -fSLo ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz http://www.dest-unreach.org/socat/download/socat-1.8.0.1.tar.gz
fi

cd ${__PROJECT__}

test -d socat && rm -rf socat
mkdir -p socat
tar --strip-components=1 -C socat -xf ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz

=======
REDIS_VERSION=6.1.0
YAML_VERSION=2.2.2
IMAGICK_VERSION=3.7.0

mkdir -p pool/ext
mkdir -p pool/lib
mkdir -p pool/php-tar

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
EXT_TEMP_CACHE_DIR=${WORK_TEMP_DIR}/pool/ext/
mkdir -p ${WORK_TEMP_DIR}
mkdir -p ${EXT_TEMP_CACHE_DIR}
test -d ${WORK_TEMP_DIR}/ext/ && rm -rf ${WORK_TEMP_DIR}/ext/
mkdir -p ${WORK_TEMP_DIR}/ext/

cd ${__PROJECT__}/pool/ext
if [ ! -f redis-${REDIS_VERSION}.tgz ]; then
  curl -fSLo ${EXT_TEMP_CACHE_DIR}/redis-${REDIS_VERSION}.tgz https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz
  mv ${EXT_TEMP_CACHE_DIR}/redis-${REDIS_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${WORK_TEMP_DIR}/ext/redis/
tar --strip-components=1 -C ${WORK_TEMP_DIR}/ext/redis/ -xf redis-${REDIS_VERSION}.tgz

: <<'EOF'
# mongodb 扩展 不支持 cygwin 环境下构建
# 详见： https://github.com/mongodb/mongo-php-driver/issues/1381

cd ${__PROJECT__}/pool/ext
if [ ! -f mongodb-${MONGODB_VERSION}.tgz ]; then
  curl -fSLo ${EXT_TEMP_CACHE_DIR}/mongodb-${MONGODB_VERSION}.tgz https://pecl.php.net/get/mongodb-${MONGODB_VERSION}.tgz
  mv ${EXT_TEMP_CACHE_DIR}/redis-${REDIS_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${WORK_TEMP_DIR}/ext/mongodb/
tar --strip-components=1 -C ${WORK_TEMP_DIR}/ext/mongodb/ -xf redis-${REDIS_VERSION}.tgz

EOF

cd ${__PROJECT__}/pool/ext
if [ ! -f yaml-${YAML_VERSION}.tgz ]; then
  curl -fSLo ${EXT_TEMP_CACHE_DIR}/yaml-${YAML_VERSION}.tgz https://pecl.php.net/get/yaml-${YAML_VERSION}.tgz
  mv ${EXT_TEMP_CACHE_DIR}/yaml-${YAML_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${WORK_TEMP_DIR}/ext/yaml/
tar --strip-components=1 -C ${WORK_TEMP_DIR}/ext/yaml/ -xf yaml-${YAML_VERSION}.tgz

cd ${__PROJECT__}/pool/ext
if [ ! -f imagick-${IMAGICK_VERSION}.tgz ]; then
  curl -fSLo ${EXT_TEMP_CACHE_DIR}/imagick-${IMAGICK_VERSION}.tgz https://pecl.php.net/get/imagick-${IMAGICK_VERSION}.tgz
  mv ${EXT_TEMP_CACHE_DIR}/imagick-${IMAGICK_VERSION}.tgz ${__PROJECT__}/pool/ext
fi
mkdir -p ${WORK_TEMP_DIR}/ext/imagick/
tar --strip-components=1 -C ${WORK_TEMP_DIR}/ext/imagick/ -xf imagick-${IMAGICK_VERSION}.tgz

cd ${__PROJECT__}/pool/ext
if [ ! -f swoole-${SWOOLE_VERSION}.tgz ]; then
  test -d ${WORK_TEMP_DIR}/swoole && rm -rf ${WORK_TEMP_DIR}/swoole
  git clone -b ${SWOOLE_VERSION} https://github.com/swoole/swoole-src.git ${WORK_TEMP_DIR}/swoole
  cd ${WORK_TEMP_DIR}/swoole
  tar -czvf ${EXT_TEMP_CACHE_DIR}/swoole-${SWOOLE_VERSION}.tgz .
  mv ${EXT_TEMP_CACHE_DIR}/swoole-${SWOOLE_VERSION}.tgz ${__PROJECT__}/pool/ext
  cd ${__PROJECT__}/pool/ext
fi
mkdir -p ${WORK_TEMP_DIR}/ext/swoole/
tar --strip-components=1 -C ${WORK_TEMP_DIR}/ext/swoole/ -xf swoole-${SWOOLE_VERSION}.tgz

cd ${__PROJECT__}
# clean extension folder
NO_BUILT_IN_EXTENSIONS=$(ls ${WORK_TEMP_DIR}/ext/)
for EXT_NAME in $NO_BUILT_IN_EXTENSIONS; do
  echo "EXTENSION_NAME: $EXT_NAME "
  test -d ${__PROJECT__}/ext/${EXT_NAME} && rm -rf ${__PROJECT__}/ext/${EXT_NAME}
done

# download php-src source code
cd ${__PROJECT__}/pool/php-tar
if [ ! -f php-${PHP_VERSION}.tar.gz ]; then
  curl -fSLo php-${PHP_VERSION}.tar.gz https://github.com/php/php-src/archive/refs/tags/php-${PHP_VERSION}.tar.gz
fi

test -d ${WORK_TEMP_DIR}/php-src && rm -rf ${WORK_TEMP_DIR}/php-src
mkdir -p ${WORK_TEMP_DIR}/php-src
tar --strip-components=1 -C ${WORK_TEMP_DIR}/php-src -xf php-${PHP_VERSION}.tar.gz

cd ${__PROJECT__}
# copy extension
# cp -rf var/cygwin-build/ext/* var/cygwin-build/php-src/ext/
cp -rf ${WORK_TEMP_DIR}/ext/* ${WORK_TEMP_DIR}/php-src/ext/

# extension hook
if [ "$X_PHP_VERSION" = "8.4" ]; then
  sed -i.backup "s/php_strtolower(/zend_str_tolower(/" ${WORK_TEMP_DIR}/php-src/ext/imagick/imagick.c
fi

# php source code hook
cd ${WORK_TEMP_DIR}/php-src
if [ "$X_PHP_VERSION" = "8.4" ] || [ "$X_PHP_VERSION" = "8.3" ] || [ "$X_PHP_VERSION" = "8.2" ] || [ "$X_PHP_VERSION" = "8.1" ]; then
  sed -i.backup 's/!defined(__HAIKU__)/!defined(__HAIKU__) \&\& !defined(__CYGWIN__)/' TSRM/TSRM.c
fi

>>>>>>> new_dev
cd ${__PROJECT__}
