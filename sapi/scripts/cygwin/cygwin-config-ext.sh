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

OPENSSH_VERSION=V_9_9_P1

while [ $# -gt 0 ]; do
  case "$1" in
  --openssh-version)
    OPENSSH_VERSION="$2"
    ;;
  --proxy)
    export GIT_PROXY_COMMAND=/tmp/git-proxy
    cat >$GIT_PROXY_COMMAND <<'___EOF___'
#!/usr/bin/env bash
PROXY_SERVER_HOST=127.0.0.1
PROXY_SERVER_PORT=8016
export PATH=$PATH:/cygdrive/c/Users/Administrator/var/socat-v1.8.0.1-cygwin-x64/socat-v1.8.0.1-cygwin-x64/
# socat - socks4a:$PROXY_SERVER_HOST:$1:$2,socksport=$PROXY_SERVER_PORT
socat - PROXY:$PROXY_SERVER_HOST:$1:$2,proxyport=$PROXY_SERVER_PORT

___EOF___

    chmod +x $GIT_PROXY_COMMAND

    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p pool/ext
mkdir -p pool/lib

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
mkdir -p ${WORK_TEMP_DIR}/openssh

cd ${__PROJECT__}/pool/lib
if [ ! -f openssh-${OPENSSH_VERSION}.tgz ]; then
  cd ${__PROJECT__}/var/
  test -d openssh && rm -rf openssh
  git clone -b ${OPENSSH_VERSION} --depth=1 git://anongit.mindrot.org/openssh.git

  cd openssh
  tar -czvf ${__PROJECT__}/pool/lib/openssh-${OPENSSH_VERSION}.tgz .

  cd ${__PROJECT__}/

fi

cd ${__PROJECT__}/
tar --strip-components=1 -C ${WORK_TEMP_DIR}/openssh -xf ${__PROJECT__}/pool/lib/openssh-${OPENSSH_VERSION}.tgz

cd ${__PROJECT__}
