#!/usr/bin/env bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

__PROJECT__=$(
  cd ${__DIR__}/../../../../../
  pwd
)
cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/var/kubernetes/
cd ${__PROJECT__}/var/kubernetes/

X_HTTP_PROXY=''
while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    X_HTTP_PROXY="$2"
    ;;

  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

# shellcheck disable=SC2034
OS=$(uname -s)
# shellcheck disable=SC2034
ARCH=$(uname -m)

systemctl status docker | cat

# 使用系统源安装 目录位置为  /lib/systemd/system/docker.service

mkdir -p /lib/systemd/system/docker.service.d/
cat >/lib/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=${X_HTTP_PROXY}"
Environment="HTTPS_PROXY=${X_HTTP_PROXY}"
Environment="NO_PROXY=0.0.0.0/8,10.0.0.0/8,100.64.0.0/10,127.0.0.0/8,172.16.0.0/12,192.168.0.0/16,localhost,.aliyuncs.com,docker.dengxiaci.com:5000"

EOF

systemctl daemon-reload
systemctl restart containerd
