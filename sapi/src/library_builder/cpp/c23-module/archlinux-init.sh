#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

sed -i '1i\\Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist


pacman -Syyu --needed --noconfirm

pacman -Sy --needed --noconfirm gcc autoconf automake make libtool cmake bison re2c  git curl llvm clang ninja
pacman -Sy --needed --noconfirm xz automake tar gzip zip unzip bzip2 pkg-config which
pacman -Sy --needed --noconfirm curl postgresql-libs c-ares sqlite unixodbc liburing linux-headers
