#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

if [ ! -f /etc/apt/sources.list.save ] ;then
  cp /etc/apt/sources.list /etc/apt/sources.list.save
fi

sed -i 's|^deb http://ftp.debian.org|deb https://mirrors.ustc.edu.cn|g' /etc/apt/sources.list
sed -i 's|^deb http://security.debian.org|deb https://mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list


if [ -f /etc/apt/sources.list.d/ceph.list ]; then
  CEPH_CODENAME=`ceph -v | grep ceph | awk '{print $(NF-1)}'`
  source /etc/os-release
  echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-$CEPH_CODENAME $VERSION_CODENAME no-subscription" > /etc/apt/sources.list.d/ceph.list
fi

if [ ! -f /etc/apt/sources.list.d/ceph.list.save ]; then
  sed -i.bak 's|http://download.proxmox.com|https://mirrors.ustc.edu.cn/proxmox|g' /etc/apt/sources.list.d/ceph.list
  sed -i.bak 's|https://enterprise.proxmox.com|https://mirrors.ustc.edu.cn/proxmox|g' /etc/apt/sources.list.d/ceph.list
fi


if [ -f /etc/apt/sources.list.d/pve-enterprise.list ] ; then
   mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.save
fi

if [ ! -f /usr/share/perl5/PVE/APLInfo.pm.save ] ; then
  cp /usr/share/perl5/PVE/APLInfo.pm /usr/share/perl5/PVE/APLInfo.pm.save
fi
sed -i.bak 's|http://download.proxmox.com|https://mirrors.ustc.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm

systemctl restart pvedaemon

apt update

# pveceph install
