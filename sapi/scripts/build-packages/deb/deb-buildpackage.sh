#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../../
  pwd
)

cd ${__DIR__}

chmod 755 swoole-cli/usr/local/bin/swoole-cli

# shellcheck disable=SC2067
find swoole-cli -type d -exec chmod 755 {} ;

dpkg -b swoole-cli ${__PROJECT__}/swoole-cli_v6.1.1.0_amd64.deb


cd ${__PROJECT__}
# dpkg -i swoole-cli_v6.1.1.0_amd64.deb

dpkg-deb -c swoole-cli_v6.1.1.0_amd64.deb # 查看包内文件列表
dpkg-deb -I swoole-cli_v6.1.1.0_amd64.deb # 查看包元信息

exit 0
# 安装测试‌
sudo dpkg -i swoole-cli_v6.1.1.0_amd64.deb # 安装包
dpkg -l swoole-cli # 验证安装
dpkg -L swoole-cli # 查看安装的文件位置
