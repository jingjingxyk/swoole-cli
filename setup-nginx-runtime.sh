#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
'Linux')
  OS="linux"
  ;;
'Darwin')
  OS="macos"
  ;;
*)
  case $OS in
  'MSYS_NT'*)
    OS="windows"
    ;;
  'MINGW64_NT'*)
    OS="windows"
    ;;
  *)
    echo '暂未配置的 OS '
    exit 0
    ;;
  esac
  ;;
esac

case $ARCH in
'x86_64')
  ARCH="x64"
  ;;
'aarch64' | 'arm64')
  ARCH="arm64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='1.28.0'
APP_NAME='nginx'
VERSION='v1.3.0'

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-nginx/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"
CACERT_DOWNLOAD_URL="https://curl.se/ca/cacert.pem"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-nginx/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-cygwin-${ARCH}.zip"
fi

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
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

case "$MIRROR" in
china)
  APP_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"
  CACERT_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/cacert.pem"
  if [ $OS = 'windows' ]; then
    APP_DOWNLOAD_URL="https://storage.jingjingxyk.com/${APP_NAME}/${APP_NAME}-${APP_VERSION}-cygwin-${ARCH}.zip"
  fi
  ;;

esac

test -f cacert.pem || curl -LSo cacert.pem ${CACERT_DOWNLOAD_URL}

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    APP_RUNTIME="${APP_NAME}-${APP_VERSION}-cygwin-${ARCH}"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.xz || curl -LSo ${APP_RUNTIME}.tar.xz ${APP_DOWNLOAD_URL}
  test -f ${APP_RUNTIME}.tar || xz -d -k ${APP_RUNTIME}.tar.xz
  test -d nginx && rm -rf nginx
  test -d nginx || tar -xvf ${APP_RUNTIME}.tar
  chmod a+x nginx/sbin/nginx
  cp -rf ${__PROJECT__}/var/runtime/nginx/. ${APP_RUNTIME_DIR}/
fi

cd ${__PROJECT__}/var/runtime

cp -f ${__PROJECT__}/var/runtime/cacert.pem ${__PROJECT__}/runtime/cacert.pem

cd ${__PROJECT__}/

tee ${APP_RUNTIME_DIR}/start.sh <<'EOF'
#!/usr/bin/env bash
set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

mkdir -p ${__DIR__}/var/log/
mkdir -p ${__DIR__}/var/run/

mkdir -p ${__DIR__}/conf/conf.d/
mkdir -p ${__DIR__}/conf/conf.d/http/
mkdir -p ${__DIR__}/conf/conf.d/stream/

${__DIR__}/sbin/nginx -p ${__DIR__}/ -t
${__DIR__}/sbin/nginx -p ${__DIR__}/

EOF

tee ${APP_RUNTIME_DIR}/reload.sh <<'EOF'
#!/usr/bin/env bash
set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


${__DIR__}/sbin/nginx -p ${__DIR__}/ -t
${__DIR__}/sbin/nginx -p ${__DIR__}/ -s reload

EOF

tee ${APP_RUNTIME_DIR}/stop.sh <<'EOF'
#!/usr/bin/env bash
set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

${__DIR__}/sbin/nginx -p ${__DIR__}/ -t
${__DIR__}/sbin/nginx -p ${__DIR__}/ -s stop

EOF

set +x

echo " "
echo " USE NGINX RUNTIME :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}:\$PATH\" "
echo " "
echo " ${APP_RUNTIME_DIR}/sbin/nginx -p ${APP_RUNTIME_DIR} "
echo " ${APP_RUNTIME_DIR}/sbin/nginx -p ${APP_RUNTIME_DIR} -t "
echo " ${APP_RUNTIME_DIR}/sbin/nginx -p ${APP_RUNTIME_DIR} -v "
echo " ${APP_RUNTIME_DIR}/sbin/nginx -p ${APP_RUNTIME_DIR} -s reload "
echo " ${APP_RUNTIME_DIR}/sbin/nginx -p ${APP_RUNTIME_DIR} -s stop "
echo " "
echo " nginx.conf example  :  https://gitee.com/jingjingxyk/quickstart-nginx/blob/main/nginx.example.conf"
echo " "
echo " nginx docs :  http://nginx.org/en/docs/configure.html"
echo " "
export PATH="${APP_RUNTIME_DIR}:$PATH"
