#!/usr/bin/env bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__PROJECT__}

OPENSSH_VERSION=V_9_9_P2

while [ $# -gt 0 ]; do
  case "$1" in
  --openssh-version)
    OPENSSH_VERSION="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p pool/ext
mkdir -p pool/lib

WORK_TEMP_DIR=${__PROJECT__}/var/msys2-build/
mkdir -p ${WORK_TEMP_DIR}/openssh

cd ${__PROJECT__}/pool/lib
if [ ! -f openssh-${OPENSSH_VERSION}.tgz ]; then
  cd ${__PROJECT__}/var/
  if [[ -d openssh ]] ; then
    rm -rf openssh
  fi
  git clone -b ${OPENSSH_VERSION} https://anongit.mindrot.org/openssh.git
  cd openssh
  tar -czvf ${__PROJECT__}/pool/lib/openssh-${OPENSSH_VERSION}.tgz .
  cd ${__PROJECT__}/
fi

cd ${__PROJECT__}/

tar --strip-components=1 -C ${WORK_TEMP_DIR}/openssh -xf ${__PROJECT__}/pool/lib/openssh-${OPENSSH_VERSION}.tgz

cd ${__PROJECT__}
