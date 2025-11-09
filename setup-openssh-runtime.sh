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
  'MSYS_NT'* | 'CYGWIN_NT'*)
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

APP_VERSION='9.9p2'
APP_NAME='openssh'
VERSION='v1.0.0'

mkdir -p runtime
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}/
SSHD_CONFIG="${APP_RUNTIME_DIR}/etc/sshd_config"

mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime

APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-openssh/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"
CACERT_DOWNLOAD_URL="https://curl.se/ca/cacert.pem"

if [ $OS = 'windows' ]; then
  APP_DOWNLOAD_URL="https://github.com/jingjingxyk/build-static-openssh/releases/download/${VERSION}/${APP_NAME}-${APP_VERSION}-msys2-${ARCH}.zip"
fi

MIRROR=''
FUNC=''
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
  --version)
    VERSION="$2"
    ;;
  --func:)
    FUNC="$2"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china)
  APP_DOWNLOAD_URL="https://php-cli-usa.jingjingxyk.com/${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}.tar.xz"
  if [ $OS = 'windows' ]; then
    APP_DOWNLOAD_URL="https://php-cli.jingjingxyk.com/${APP_NAME}-${APP_VERSION}-msys2-${ARCH}.zip"
  fi
  CACERT_DOWNLOAD_URL="https://php-cli-usa.jingjingxyk.com/cacert.pem"
  ;;

esac

test -f cacert.pem || curl -LSo cacert.pem ${CACERT_DOWNLOAD_URL}

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    APP_RUNTIME="${APP_NAME}-${APP_VERSION}-msys2-${ARCH}"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.xz || curl -LSo ${APP_RUNTIME}.tar.xz ${APP_DOWNLOAD_URL}
  test -f ${APP_RUNTIME}.tar || xz -d -k ${APP_RUNTIME}.tar.xz
  test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
  test -d ${APP_NAME}/ && rm -rf ${APP_NAME}/
  mkdir -p ${APP_NAME}/
  tar -xvf ${APP_RUNTIME}.tar -C ${APP_NAME}/

  mkdir -p ${__PROJECT__}/runtime/${APP_NAME}
  test -d ${__PROJECT__}/runtime/${APP_NAME} && rm -rf ${__PROJECT__}/runtime/${APP_NAME}
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/. ${APP_RUNTIME_DIR}
fi

cd ${__PROJECT__}/var/runtime

cp -f ${__PROJECT__}/var/runtime/cacert.pem ${__PROJECT__}/runtime/cacert.pem

cd ${__PROJECT__}/

tee ${APP_RUNTIME_DIR}/opensshd-start.sh <<'EOF'
#!/usr/bin/env bash
set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}/
# test config file
${__DIR__}/sbin/sshd -t -f   ${__DIR__}/etc/sshd_config

${__DIR__}/sbin/sshd -D -e -f   ${__DIR__}/etc/sshd_config

EOF

T__PROJECT__=$(echo "${__PROJECT__}" | sed "s|/|\\\/|g")
T_APP_RUNTIME_DIR=$(echo "${APP_RUNTIME_DIR}" | sed "s|\/|\\\/|g")
sed -i.bak "s@\/usr\/local\/swoole-cli@${T__PROJECT__}\/runtime@" $SSHD_CONFIG
sed -i.bak "s@\.ssh\/authorized_keys@${T_APP_RUNTIME_DIR}\/\.ssh\/authorized_keys@" $SSHD_CONFIG
sed -i.bak 's/^#HostKey/HostKey/g' $SSHD_CONFIG

echo 'Port 65527' >>$SSHD_CONFIG
echo 'AddressFamily any' >>$SSHD_CONFIG
echo 'PasswordAuthentication no' >>$SSHD_CONFIG
echo 'PermitRootLogin yes' >>$SSHD_CONFIG
echo 'PubkeyAuthentication yes' >>$SSHD_CONFIG
echo 'LogLevel DEBUG' >>$SSHD_CONFIG
echo "PidFile ${APP_RUNTIME_DIR}/var/run/sshd.pid" >>$SSHD_CONFIG
echo "AllowTcpForwarding yes" >>$SSHD_CONFIG
echo "GatewayPorts yes" >>$SSHD_CONFIG
echo "PermitOpen any" >>$SSHD_CONFIG

mkdir -p ${APP_RUNTIME_DIR}/var/run/
mkdir -p ${APP_RUNTIME_DIR}/.ssh/
touch ${APP_RUNTIME_DIR}/.ssh/authorized_keys

set +x

echo " "
echo " USE openssh RUNTIME :"
echo " "
echo " change config file ${APP_RUNTIME_DIR}/etc/sshd_config "
echo ' GENERATE SSH KEY :'
echo " ${APP_RUNTIME_DIR}/bin/ssh-keygen -N \"\" -t ed25519 -C \"Example-SSH-Key\" -f example_ssh_key"
echo ' RUN SSHD :'
echo " bash ${APP_RUNTIME_DIR}/opensshd-start.sh"
echo '  '
echo " ssh client example:"
echo " cat example_ssh_key.pub >> ${APP_RUNTIME_DIR}/.ssh/authorized_keys"
echo " ssh -o StrictHostKeyChecking=no -p 65527 -i example_ssh_key -v -CNT -D 0.0.0.0:$(date +%Y) $(id -un)@127.0.0.1"

export PATH="${APP_RUNTIME_DIR}/bin/:${APP_RUNTIME_DIR}/sbin/:$PATH"
