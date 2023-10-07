#!/bin/bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__PROJECT__}

MIRROR=''
while [ $# -gt 0 ]; do
  case "$1" in
  --mirror)
    MIRROR="$2"
    shift
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china)

  export HOMEBREW_INSTALL_FROM_API=1
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

  export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

  # 参考文档： https://help.mirrors.cernet.edu.cn/homebrew/
  ;;

esac

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

brew update

brew install wget curl libtool automake re2c llvm flex bison
brew install gettext coreutils binutils libunistring

brew uninstall --ignore-dependencies snappy
brew uninstall --ignore-dependencies capstone


case "$MIRROR" in
china|tuna)
  pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  ;;
ustc)
  pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple
  ;;

esac

pip3 install meson
