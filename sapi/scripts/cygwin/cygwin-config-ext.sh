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

SOCAT_VERSION='1.8.0.3'

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

cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/pool/
mkdir -p ${__PROJECT__}/var/
mkdir -p pool/ext
mkdir -p pool/lib

# download socat source code
# https://repo.or.cz/socat.git

if [ ! -f ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz ]; then
  cd ${__PROJECT__}/var/
  test -d socat && rm -rf socat
  git clone -b tag-${SOCAT_VERSION} https://repo.or.cz/socat.git
  cd socat
  curl -Lo cacert.pem https://curl.se/ca/cacert.pem
  tar -czvf ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz .
  cd ${__PROJECT__}

  # curl -fSLo ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz http://www.dest-unreach.org/socat/download/socat-1.8.0.1.tar.gz
fi

cd ${__PROJECT__}
WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
mkdir -p ${WORK_TEMP_DIR}
cd ${WORK_TEMP_DIR}/

test -d socat && rm -rf socat
mkdir -p socat
tar --strip-components=1 -C socat -xf ${__PROJECT__}/pool/socat-${SOCAT_VERSION}.tar.gz

cd ${__PROJECT__}
