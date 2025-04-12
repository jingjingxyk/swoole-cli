#!/usr/bin/env bash

set -x

brew doctor

brew missing

exit 0

brew list --formula --built-from-source
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_FORCE_BREWED_GIT=1

# macOS 12 unsupported?
# https://github.com/orgs/Homebrew/discussions/5603

brew untap
brew untap  Homebrew/homebrew-cask-versions
brew untap  Homebrew/homebrew-services

brew cleanup
