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
cd ${__PROJECT__}

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},127.0.0.1,localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn"
    NO_PROXY="${NO_PROXY},.tencent.com"
    NO_PROXY="${NO_PROXY},.sourceforge.net"
    NO_PROXY="${NO_PROXY},.npmmirror.com"
    export NO_PROXY="${NO_PROXY}"
    ;;

  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

mkdir -p ${__PROJECT__}/var/openwrt/

cd ${__PROJECT__}/var/openwrt/

# 参考
# https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm#troubleshooting

test -f openwrt-23.05.5-x86-64-generic-ext4-combined.img.gz || curl -fSLo openwrt-23.05.5-x86-64-generic-ext4-combined.img.gz https://archive.openwrt.org/releases/23.05.5/targets/x86/64/openwrt-23.05.5-x86-64-generic-ext4-combined.img.gz

test -f openwrt-23.05.5-x86-64-generic-ext4-combined.img || gunzip openwrt-*.img.gz
test -f openwrt.img && rm -f openwrt.img
dd if=openwrt-23.05.5-x86-64-generic-ext4-combined.img of=openwrt.img bs=128000 conv=sync

test -f openwrt.vdi && rm -f openwrt.vdi
VBoxManage convertfromraw --format VDI openwrt.img openwrt.vdi
# VBoxManage modifymedium openwrt.vdi --resize 128


