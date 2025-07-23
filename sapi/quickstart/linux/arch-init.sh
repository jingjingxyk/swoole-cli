#!/usr/bin/env sh

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    ;;
  --*)
    echo "no found mirror option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china | tuna)
  test -f /etc/pacman.d/mirrorlist.save || cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.save
  sed -i '1i\\Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
  ;;
esac

pacman -Syyu --needed --noconfirm

pacman -Sy --needed --noconfirm gcc autoconf automake make libtool cmake bison re2c git curl llvm clang ninja
pacman -Sy --needed --noconfirm xz automake tar gzip zip unzip bzip2 pkg-config which
pacman -Sy --needed --noconfirm curl postgresql-libs c-ares sqlite unixodbc liburing linux-headers
