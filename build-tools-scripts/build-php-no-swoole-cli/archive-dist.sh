#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)

cd ${__DIR__}

version=$(cat version.txt)


install_prefix_dir="/tmp/${version}"
${install_prefix_dir}/bin/php -v

ls -lh ${install_prefix_dir}/bin/php
# 移除符号表
# strip ${install_prefix_dir}/bin/php

ls -lh ${install_prefix_dir}/bin/php

mkdir -p dist/
cp -rf ${install_prefix_dir}/bin/php ${install_prefix_dir}/bin/${version}
cp -rf ${install_prefix_dir}/bin/${version} dist/
