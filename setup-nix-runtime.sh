#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

# doc : https://nix.dev/
# install doc : https://github.com/NixOS/nix#installation
# https://nixos.org/download/#nix-install-linux

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

# https://releases.nixos.org/nix/nix-2.30.1/install
# https://nixos.org/nix/install

# method 1
# curl -fsSL https://nixos.org/nix/install | sh -s -- --help
# curl -fsSL https://nixos.org/nix/install | sh -s -- --daemon
curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon

exit 0
# method 2
export VERSION=2.19.2
curl -L https://releases.nixos.org/nix/nix-$VERSION/install | sh

# method 3
pushd $(mktemp -d)
export VERSION=2.19.2
export SYSTEM=x86_64-linux
curl -LO https://releases.nixos.org/nix/nix-$VERSION/nix-$VERSION-$SYSTEM.tar.xz
tar xfj nix-$VERSION-$SYSTEM.tar.xz
cd nix-$VERSION-$SYSTEM
./install
popd
