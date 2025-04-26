#!/usr/bin/env bash

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

mkdir -p ${__PROJECT__}/var

# shellcheck disable=SC2164
cd ${__PROJECT__}/var

MIRROR=''
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
    NO_PROXY="${NO_PROXY},localhost"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

case "$MIRROR" in
china)
  git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
  bash brew-install/install.sh
  rm -rf brew-install
  ;;
*)
  export HOMEBREW_API_DOMAIN="https://api.brew.sh"

  export HOMEBREW_BREW_GIT_REMOTE="https://github.com/homebrew/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://github.com/homebrew/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://ghcr.io/v2/homebrew/core"

  export HOMEBREW_PIP_INDEX_URL="https://pypi.org/simple"
  export PIPENV_PYPI_MIRROR="https://pypi.org/simple"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ;;
esac

brew config
