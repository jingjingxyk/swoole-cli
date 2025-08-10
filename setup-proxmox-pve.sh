#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/var/

# Proxmox 软件源
# 教育网联合镜像站
# https://mirrors.cernet.edu.cn/proxmox
# https://mirrors.cernet.edu.cn/list/proxmox
# homepage
# https://www.proxmox-pve.com.c
# https://pve.proxmox.com/wiki/Main_Page

# curl -LSo proxmox-ve_9.0-1.iso https://mirrors.cqupt.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso

if [ -f runtime/aria2c/aria2c ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-aria2-runtime.sh?raw=ture | bash -s -- --mirror china
fi
export PATH="${__PROJECT__}/runtime/aria2c/:$PATH"
which aria2c

aria2c -c -x4 -s8 \
  https://mirrors.bfsu.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso \
  https://mirrors.cqupt.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso \
  https://mirrors.hit.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso \
  https://mirror.iscas.ac.cn/proxmox/iso/proxmox-ve_9.0-1.iso \
  https://mirror.nju.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso \
  https://mirrors.tuna.tsinghua.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso

# https://mirror.nyist.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso \
# https://mirrors.ustc.edu.cn/proxmox/iso/proxmox-ve_9.0-1.iso
