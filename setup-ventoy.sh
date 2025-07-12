#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

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

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/

# ventoy
# show file
# https://sourceforge.net/projects/ventoy/files
# homepage
# https://www.ventoy.net/cn/

curl -LSo ventoy-1.1.05-livecd.iso https://github.com/ventoy/Ventoy/releases/download/v1.1.05/ventoy-1.1.05-livecd.iso
curl -LSo ventoy-1.1.05-linux.tar.gz https://github.com/ventoy/Ventoy/releases/download/v1.1.05/ventoy-1.1.05-linux.tar.gz

# iventor PXE
# homepage
# https://www.iventoy.com/
# startup doc
# https://www.iventoy.com/cn/doc_start.html
# bash iventoy.sh start
# bash iventoy.sh -R start
curl -LSo iventoy-1.0.21-linux-free.tar.gz https://github.com/ventoy/PXE/releases/download/v1.0.21/iventoy-1.0.21-linux-free.tar.gz
curl -LSo iventoy-1.0.21-win64-free.zip https://github.com/ventoy/PXE/releases/download/v1.0.21/iventoy-1.0.21-win64-free.zip


exit 0
