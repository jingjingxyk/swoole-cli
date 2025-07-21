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
  OS="unknown-linux-musl"
  ;;
'Darwin')
  OS="darwin"
  OS="apple-darwin"
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
  ARCH="x86_64"
  ;;
'aarch64' | 'arm64')
  ARCH="aarch64"
  ;;
*)
  echo '暂未配置的 ARCH '
  exit 0
  ;;
esac

APP_VERSION='1.0.0-alpha.32'
APP_NAME='rustfs'
VERSION="1.0.0-alpha.32"

cd ${__PROJECT__}
mkdir -p runtime/
mkdir -p var/runtime
APP_RUNTIME_DIR=${__PROJECT__}/runtime/${APP_NAME}
mkdir -p ${APP_RUNTIME_DIR}

cd ${__PROJECT__}/var/runtime
# https://github.com/rustfs/rustfs/

# https://github.com/rustfs/rustfs/releases/download/1.0.0-alpha.6/rustfs-aarch64-apple-darwin.tar.gz
# https://github.com/rustfs/rustfs/releases/download/1.0.0-alpha.6/rustfs-gui-aarch64-apple-darwin.tar.gz
# https://github.com/rustfs/rustfs/releases/download/1.0.0-alpha.6/rustfs-aarch64-unknown-linux-musl.tar.gz
# https://github.com/rustfs/rustfs/releases/download/1.0.0-alpha.6/rustfs-x86_64-unknown-linux-musl.tar.gz

APP_DOWNLOAD_URL="https://github.com/rustfs/rustfs/releases/download/${VERSION}/${APP_NAME}-${ARCH}-${OS}.tar.gz"

while [ $# -gt 0 ]; do
  case "$1" in
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

APP_RUNTIME="${APP_NAME}-${APP_VERSION}-${OS}-${ARCH}"

if [ $OS = 'windows' ]; then
  {
    APP_RUNTIME="${APP_NAME}-${APP_VERSION}-windows-${ARCH}"
    test -f ${APP_RUNTIME}.zip || curl -LSo ${APP_RUNTIME}.zip ${APP_DOWNLOAD_URL}
    test -d ${APP_RUNTIME} && rm -rf ${APP_RUNTIME}
    unzip "${APP_RUNTIME}.zip"
    exit 0
  }
else
  test -f ${APP_RUNTIME}.tar.gz || curl -LSo ${APP_RUNTIME}.tar.gz ${APP_DOWNLOAD_URL}
  test -d ${APP_NAME} && rm -rf ${APP_NAME}
  mkdir -p ${APP_NAME}
  tar --strip-components=1 -C ${APP_NAME} -xvf ${APP_RUNTIME}.tar.gz
  cp -rf ${__PROJECT__}/var/runtime/${APP_NAME}/ ${APP_RUNTIME_DIR}/
  chmod a+x ${APP_RUNTIME_DIR}/bin/rustfs
fi

cd ${__PROJECT__}/

set +x
: <<'EOF'

podman run -d -p 9000:9000 -p 9001:9001 -v /data:/data quay.io/rustfs/rustfs

打开 Web 浏览器并导航到 http://localhost:9001 以访问 RustFS 控制台，默认的用户名和密码是 rustfsadmin

EOF

cat >${APP_RUNTIME_DIR}/start.sh <<'EOF'
#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}
mkdir -p data
./bin/rustfs --console-enable --address 0.0.0.0:9000 --console-address 0.0.0.0:9001 data

EOF

echo " "
echo " USE rustfs :"
echo " "
echo " export PATH=\"${APP_RUNTIME_DIR}/bin/:\$PATH\" "
echo " "
echo " rustfs docs :  https://github.com/rustfs/rustfs/blob/main/README_ZH.md "
echo " "
echo " "
export PATH="${APP_RUNTIME_DIR}/bin/:$PATH"
rustfs --help
