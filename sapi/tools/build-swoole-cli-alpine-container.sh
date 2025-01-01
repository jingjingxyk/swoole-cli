#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)

cd ${__DIR__}
cd ${__PROJECT__}

test -d var/build-swoole-cli-container/ && rm -rf var/build-swoole-cli-container/
mkdir -p var/build-swoole-cli-container/
cd ${__PROJECT__}/var/build-swoole-cli-container/

cp ${__PROJECT__}/setup-swoole-cli-runtime.sh .
#bash setup-swoole-cli-runtime.sh --proxy socks5h://127.0.0.1:7890
bash setup-swoole-cli-runtime.sh --proxy http://172.23.24.221:8010 --version v5.1.6.0

exit 0

cat >php.ini <<'EOF'
curl.cainfo="/usr/local/swoole-cli/etc/cacert.pem"
openssl.cafile="/usr/local/swoole-cli/etc/cacert.pem"
swoole.use_shortname=off
display_errors = On
error_reporting = E_ALL

upload_max_filesize="128M"
post_max_size="128M"
memory_limit="1G"
date.timezone="UTC"

opcache.enable=On
opcache.enable_cli=On
opcache.jit=1225
opcache.jit_buffer_size=128M

; jit 更多配置参考 https://mp.weixin.qq.com/s/Tm-6XVGQSlz0vDENLB3ylA

expose_php=Off
apc.enable_cli=1

EOF

cat >Dockerfile <<'EOF'
FROM alpine:3.20

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /usr/local/swoole-cli/etc/conf.d/
ADD ./bin/runtime/swoole-cli /usr/local/bin/
ADD ./bin/runtime/composer /usr/local/bin/
ADD ./bin/runtime/cacert.pem /usr/local/swoole-cli/etc/
ADD ./php.ini /usr/local/swoole-cli/etc/

RUN chmod a+x /usr/local/bin/swoole-cli
RUN chmod a+x /usr/local/bin/composer
RUN ln -sf /usr/local/bin/swoole-cli /usr/local/bin/php

ARG MIRROR=""
RUN test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
RUN if [ "${MIRROR}" = "ustc" -o "${MIRROR}" = "china"   ]; then { sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories ; } fi
RUN if [ "${MIRROR}" = "tuna" ]; then { sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories ; } fi

RUN apk add ca-certificates tini

RUN mkdir /work
WORKDIR /work
ENTRYPOINT ["tini", "--"]

EOF

PLATFORM=''
ARCH=$(uname -m)
case $ARCH in
'x86_64')
  PLATFORM='linux/amd64'
  ;;
'aarch64')
  PLATFORM='linux/arm64'
  ;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
  --platform)
    PLATFORM="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

TIME=$(date -u '+%Y%m%dT%H%M%SZ')
ARCH=$(uname -m)
VERSION="1.0.0"
TAG="alpine-3.20-v${VERSION}-${ARCH}-${TIME}"
IMAGE="docker.io/jingjingxyk/swoole-cli:${TAG}"

MIRROR='china'
docker buildx build -t ${IMAGE} -f ./Dockerfile . --platform ${PLATFORM} --build-arg="MIRROR=${MIRROR}"

echo ${IMAGE}
docker save -o "swoole-cli-image.tar" ${IMAGE}

docker run --rm --name demo ${IMAGE} swoole-cli -v
docker run --rm --name demo ${IMAGE} swoole-cli -m
docker run --rm --name demo ${IMAGE} swoole-cli --ri swoole
