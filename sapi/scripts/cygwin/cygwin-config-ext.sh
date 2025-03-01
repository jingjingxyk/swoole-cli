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

PRIVOXY_VERSION='3.0.34'

while [ $# -gt 0 ]; do
  case "$1" in
  --privoxy-version)
    PRIVOXY_VERSION="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p pool/lib

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
mkdir -p ${WORK_TEMP_DIR}

cd ${__PROJECT__}/pool/lib/
if [ ! -f privoxy-${PRIVOXY_VERSION}.tgz ]; then
  curl -fSLo var/privoxy-${PRIVOXY_VERSION}.tgz 'https://sourceforge.net/projects/ijbswa/files/Sources/3.0.34%20(stable)/privoxy-3.0.34-stable-src.tar.gz'
  ''
  mv var/privoxy-${PRIVOXY_VERSION}.tgz ${__PROJECT__}/pool/lib/privoxy-${PRIVOXY_VERSION}.tgz
fi
mkdir -p ${WORK_TEMP_DIR}/privoxy
tar --strip-components=1 -C ${WORK_TEMP_DIR}/privoxy -xf privoxy-${PRIVOXY_VERSION}.tgz

cd ${__PROJECT__}
