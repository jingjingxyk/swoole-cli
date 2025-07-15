#!/usr/bin/env bash
#set -euo pipefail

set -eux
set -o pipefail

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

OVS_TAG='v3.4.2'
OVN_TAG='v24.09.2'
# OVN_TAG='v25.03.0'

CPU_NUMS=$(nproc)
CPU_NUMS=$(grep "processor" /proc/cpuinfo | sort -u | wc -l)

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"

MIRROR=''
FORCE_INSTALL_DEPS=0
FORCE_INSTALL=0
DEBIAN_APT_INSTALL=0

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
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    NO_PROXY="${NO_PROXY},ftpmirror.gnu.org"
    NO_PROXY="${NO_PROXY},gitee.com,gitcode.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    NO_PROXY="${NO_PROXY},dl-cdn.alpinelinux.org"
    NO_PROXY="${NO_PROXY},deb.debian.org,security.debian.org"
    NO_PROXY="${NO_PROXY},archive.ubuntu.com,security.ubuntu.com"
    NO_PROXY="${NO_PROXY},pypi.python.org,bootstrap.pypa.io"
    export NO_PROXY="${NO_PROXY},localhost"
    ;;
  --install-deps)
    FORCE_INSTALL_DEPS=1
    ;;
  --force)
    FORCE_INSTALL=1
    ;;
  --debian-install)
    DEBIAN_APT_INSTALL=1
    ;;
  --set-cpu-num)
    CPU_NUMS=$2
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

debian_install_deps() {

  apt update -y
  apt install -y locales
  echo 'en_US.UTF-8 UTF-8' >>/etc/locale.gen
  locale-gen
  localedef -i en_US -f UTF-8 en_US.UTF-8
  locale -a | grep en_US.utf8
  export LANGUAGE="en_US.UTF-8"
  export LC_ALL="en_US.UTF-8"
  export LC_CTYPE="en_US.UTF-8"
  export LANG="en_US.UTF-8"

  # update-locale LANG=en_US.UTF-8

  apt install -y git curl python3 python3-pip python3-dev wget sudo file
  apt install -y libssl-dev ca-certificates

  apt install -y \
    git gcc clang make cmake autoconf automake openssl libssl-dev python3 python3-pip libtool \
    openssl curl libcap-ng-dev uuid uuid-runtime

  apt install -y ntp
  # apt install -y ntpsec

  apt install -y kmod iptables
  apt install -y tcpdump nmap traceroute net-tools dnsutils iproute2 procps iputils-ping
  apt install -y conntrack
  apt install -y bridge-utils
  apt install -y libelf-dev libbpf-dev # libxdp-dev
  apt install -y graphviz
  apt install -y libjemalloc2 libjemalloc-dev libnuma-dev libpcap-dev libunbound-dev libunwind-dev llvm-dev
  apt install -y bc init ncat
  apt install -y lshw
  # apt install -y isc-dhcp-server
  # apt install -y libdpdk-dev

  # apt install -y ntp ntpdate
  # ‌手动强制同步‌
  # ntpdate ntp.ntsc.ac.cn  # 使用国家授时中心服务器
  # ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

  # apt install ntp systemd-timesyncd -y
  # timedatectl set-ntp true
  # systemctl disable systemd-timesyncd
  # timedatectl status
  # timedatectl set-timezone Asia/Shanghai
  # timedatectl set-timezone UTC
  # timedatectl set-local-rtc 0  # 将硬件时钟设为UTC

  # apt install ntp ntpsec -y
  ntpq -pn

  # debian.map.fastlydns.net

}
alpine_install_deps() {
  apk add bash linux-headers autoconf automake make libtool cmake bison re2c coreutils gcc g++
  apk add bash zip unzip flex pkgconf ca-certificates
  apk add tar gzip zip unzip bzip2
  apk add 7zip
  apk add gettext gettext-dev
  apk add wget git curl
  apk add nasm
  apk add ninja python3 python3-dev
  apk add diffutils
  apk add socat
  apk add pigz parallel
  apk add gnupg
  apk add openssl-dev
  apk add libbpf-dev
  apk add libcap-ng-dev
  apk add bind-dev
  apk add bind-tools
  apk add jemalloc jemalloc-dev numactl-dev libpcap-dev unbound-dev libunwind-dev
  apk add tcpdump nmap net-tools iproute2 procps iputils-ping
  apk add ndisc6
  apk add pciutils
  apk add iptables

  # 完整的 DNS 服务器软件
  # dnsmasq unbound bind
}
openwrt_install_deps() {
  opkg update
  opkg install libustream-openssl ca-bundle ca-certificates
  opkg install curl bash git xz unzip
  opkg install wireguard-tools
}

debian_apt_install() {
  apt install -y ovn-central ovn-common ovn-controller-vtep ovn-docker ovn-host
  apt install -y ovn-ic ovn-ic-db
  apt install -y openvswitch-switch openvswitch-common openvswitch-ipsec openvswitch-pki
  apt install -y openvswitch-switch-dpdk openvswitch-vtep python3-openvswitch
}

OS_ID=$(cat /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
VERSION_ID=$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F '=' '{print $2}' | sed "s/\"//g")

if [ "${OS_ID}" = 'debian' ] || [ "${OS_ID}" = 'ubuntu' ] || [ "${OS_ID}" = 'alpine' ] || [ "${OS_ID}" = "openwrt" ]; then
  echo 'supported OS'
else
  echo 'no supported OS'
  exit 0
fi

if test -n "$MIRROR"; then
  {
    case $OS_ID in
    debian)
      case $VERSION_ID in
      11 | 12)
        # debian 容器内和容器外 镜像源配置不一样
        if [ -f /.dockerenv ] && [ "$VERSION_ID" = 12 ]; then
          test -f /etc/apt/sources.list.d/debian.sources.save || cp -f /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.save
          sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
          sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
          test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list.d/debian.sources
          # 云服务内网镜像源
          test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list.d/debian.sources
          test "$MIRROR" = "tencentyun" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tencentyun.com@g" /etc/apt/sources.list.d/debian.sources
          test "$MIRROR" = "huaweicloud" && sed -i "s@mirrors.ustc.edu.cn@repo.huaweicloud.com@g" /etc/apt/sources.list.d/debian.sources
        else
          test -f /etc/apt/sources.list.save || cp /etc/apt/sources.list /etc/apt/sources.list.save
          sed -i "s@deb.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
          sed -i "s@security.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
          test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
          test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list
          test "$MIRROR" = "tencentyun" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tencentyun.com@g" /etc/apt/sources.list
          test "$MIRROR" = "huaweicloud" && sed -i "s@mirrors.ustc.edu.cn@repo.huaweicloud.com@g" /etc/apt/sources.list
        fi
        ;;
      *)
        echo 'no match debian OS version' . $VERSION_ID
        ;;
      esac
      ;;
    ubuntu)
      case $VERSION_ID in
      20.04 | 22.04 | 22.10 | 23.04 | 23.10)
        test -f /etc/apt/sources.list.save || cp /etc/apt/sources.list /etc/apt/sources.list.save
        sed -i "s@security.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        sed -i "s@archive.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
        test "$MIRROR" = "tuna" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
        test "$MIRROR" = "aliyuncs" && sed -i "s@mirrors.ustc.edu.cn@mirrors.cloud.aliyuncs.com@g" /etc/apt/sources.list
        test "$MIRROR" = "tencentyun" && sed -i "s@mirrors.ustc.edu.cn@mirrors.tencentyun.com@g" /etc/apt/sources.list
        test "$MIRROR" = "huaweicloud" && sed -i "s@mirrors.ustc.edu.cn@repo.huaweicloud.com@g" /etc/apt/sources.list
        ;;
      24.04)
        test -f /etc/apt/sources.list.d/ubuntu.sources.save || cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.save
        sed -i "s@security.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list.d/ubuntu.sources
        sed -i "s@archive.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list.d/ubuntu.sources
        ;;
      *)
        echo 'no match ubuntu OS version' . $VERSION_ID
        ;;
      esac
      ;;
    alpine)
      test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
      test "$MIRROR" = "china" && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
      test "$MIRROR" = "tuna" && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
      test "$MIRROR" = "ustc" && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
      ;;
    "openwrt")
      test -f /etc/opkg/distfeeds.conf.save || cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.save

      test "$MIRROR" = "china" && sed -i 's/downloads.openwrt.org/mirrors.tuna.tsinghua.edu.cn\/openwrt/g' /etc/apk/repositories
      test "$MIRROR" = "tuna" && sed -i.bak 's/downloads.openwrt.org/mirrors.ustc.edu.cn\/openwrt/g' /etc/opkg/distfeeds.conf
      test "$MIRROR" = "ustc" && sed -i.bak 's/downloads.openwrt.org/mirrors.tuna.tsinghua.edu.cn\/openwrt/g' /etc/opkg/distfeeds.conf

      ;;
    *)
      echo 'NO SUPPORT LINUX OS'
      exit 0
      ;;
    esac
  }
fi

install_deps() {
  case $OS_ID in
  'debian' | 'ubuntu')
    debian_install_deps
    ;;
  'alpine')
    alpine_install_deps
    ;;
  'openwrt')
    openwrt_install_deps
    ;;
  *) ;;
  esac
}

if [[ $DEBIAN_APT_INSTALL -eq 1 ]]; then
  debian_apt_install
  exit 0
fi

if [[ "$FORCE_INSTALL_DEPS" -eq 1 ]]; then
  install_deps
else
  # test $(dpkg-query -l graphviz | wc -l) -eq 0 && install_deps
  test $(command -v bc | wc -l) -eq 0 && install_deps
fi

cd ${__DIR__}
if [[ "$FORCE_INSTALL" -eq 1 ]]; then
  test -d ${__DIR__}/ovs/ && rm -rf ${__DIR__}/ovs/
  test -d ${__DIR__}/ovn/ && rm -rf ${__DIR__}/ovn/
fi

if test -d ovs; then
  cd ${__DIR__}/ovs/
  # git   pull --depth=1 --progress --rebase
else
  if [[ "$MIRROR" == "china" ]]; then
    git clone -b ${OVS_TAG} https://gitee.com/jingjingxyk/ovs.git --depth=1 --progress
  else
    git clone -b ${OVS_TAG} https://github.com/openvswitch/ovs.git --depth=1 --progress
  fi
fi

cd ${__DIR__}

if test -d ovn; then
  cd ${__DIR__}/ovn/
  # git   pull --depth=1 --progress --rebase
else
  if [[ "$MIRROR" == "china" ]]; then
    git clone -b ${OVN_TAG} https://gitee.com/jingjingxyk/ovn.git --depth=1 --progress
  else
    git clone -b ${OVN_TAG} https://github.com/ovn-org/ovn.git --depth=1 --progress
  fi

fi

cd ${__DIR__}

cd ${__DIR__}/ovs/
./boot.sh
cd ${__DIR__}/ovs/

./configure --help

sed -i '5i\touch $stamp ; exit 0 ;' ./build-aux/cksum-schema-check

./configure --enable-ssl
make -j $CPU_NUMS
make install

cd ${__DIR__}/ovn/

./boot.sh
cd ${__DIR__}/ovn/
sed -i '5i\touch $stamp ; exit 0 ;' ./build-aux/cksum-schema-check
./configure --help
./configure --enable-ssl \
  --with-ovs-source=${__DIR__}/ovs/ \
  --with-ovs-build=${__DIR__}/ovs/

make -j $CPU_NUMS
make install

cd ${__DIR__}
rm -rf ${__DIR__}/ovn
rm -rf ${__DIR__}/ovs

# https://wiki.debian.org/SourcesList

# sed -i "s@mirrors.tuna.tsinghua.edu.cn@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
# sed -i "s@mirrors.tuna.tsinghua.edu.cn@archive.debian.org@g" /etc/apt/sources.list
# sed -i "s@mirrors.aliyun.com@archive.debian.org@g" /etc/apt/sources.list

# sed -i "s@mirrors.aliyun.com@deb.debian.org@g" /etc/apt/sources.list

# 在 LTS 结束后，对应发行版的软件源会被从 Debian 主源中删除，移动到 archive.debian.org
# https://mirrors.tuna.tsinghua.edu.cn/help/debian-elts/
# sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
# sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list

# 升级 debian 10 升级 debian 11
# sed -i 's/buster/bullseye/g' /etc/apt/sources.list
# apt full-upgrade -y

: <<'COMMENT'
test -f /etc/apt/apt.conf.d/proxy.conf && rm -f /etc/apt/apt.conf.d/proxy.conf

cat > /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy  "http://127.0.0.1:8016";
Acquire::https::Proxy "http://127.0.0.1:8016";
Acquire::NoProxy "127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,::1/128,fe80::/10,fd00::/8,ff00::/8,.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com,localhost";
EOF

COMMENT
