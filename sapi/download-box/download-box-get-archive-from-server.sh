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

mkdir -p  pool/lib
mkdir -p  pool/ext

test -d ${__PROJECT__}/var/download-box/ || mkdir -p ${__PROJECT__}/var/download-box/

cd ${__PROJECT__}/var/download-box/

ALL_DEPS_HASH="5fa1485c2408f05cbc548712917e6dbb8ecd5a631b558d6d512d4a6671f071e5"

DOMAIN='https://github.com/swoole/swoole-cli/releases/download/v5.1.3.0/'
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    if [ "$2" = 'china' ] ; then
      DOMAIN='https://swoole-cli.jingjingxyk.com/'
    fi
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done


URL="${DOMAIN}/all-deps.zip"

test -f  all-deps.zip || curl -Lo  all-deps.zip ${URL}

# hash 签名
HASH=$(sha256sum all-deps.zip | awk '{print $1}')

# 签名验证失败，删除下载文件
if [ ${HASH} !=	 ${ALL_DEPS_HASH} ] ; then
    echo 'hash signature is invalid ！'
    rm -f all-deps.zip
    exit 0
fi

unzip -n all-deps.zip

cd ${__PROJECT__}/

awk 'BEGIN { cmd="cp -ri var/download-box/lib/* pool/lib"  ; print "n" |cmd; }'
awk 'BEGIN { cmd="cp -ri var/download-box/ext/* pool/ext"; print "n" |cmd; }'

echo "download all-archive.zip ok ！"
