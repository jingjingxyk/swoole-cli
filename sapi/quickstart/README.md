# 快速开始

## [linux 版](./linux/linux/README.md)

> `php prepare.php --with-build-type=dev +apcu +ds -gd -zip -imagick`
> gd 库 libXpm 编译不成功，libzip 需要降低版本 ，imagick 依赖libzip
> 需要重新编译curl ; php7.33 依赖库curl 不包含 nghttp2
> (curl 包含nghttp2 与 swoole 里面包含的 nghttp2 冲突，保留 swoole 内置的nghttp2)

## macos

# 快速初始化构建环境

## 一个脚本执行整个构建流程

> 定制 build-release-php.sh 脚本 即可开始构建

```bash

cp  build-release-example.sh  build-release-php.sh

bash build-release-php.sh

```

## [构建选项](../../docs/options.md)

## [linux 环境下构建 完整步骤](../../docs/linux.md)

## [macos 环境下构建 完整步骤](../../docs/macOS.md)

## [cygwin](../../docs/Cygwin.md)

## [wsl](../../docs/wsl.md)

## 准备运行环境 (linux/macos/windows)

1. [ linux 快速启动 容器 构建环环境 ](linux/README.md)
1. [ windows cygwin 快速启动 构建环环境 ](windows/README.md)
1. [ macos 快速启动 构建环环境 ](macos/README.md)
1. [ 构建选项 ](../../docs/options.md)

## 相同功能命令 不同写法

```shell

git clone --recursive https://github.com/swoole/swoole-cli.git

git submodule update --init --recursive

```

## PHP 版本变更详情

1. [PHP 8.1.x 升级到 PHP 8.2.x  的变更](https://www.php.net/manual/zh/migration82.php)
1. [PHP 8.0.x 升级到 PHP 8.1.x  的变更](https://www.php.net/manual/zh/migration81.php)
1. [PHP 7.4.x 升级到 PHP 8.0.x  的变更](https://www.php.net/manual/zh/migration80.php)

## [PHP 版本查看](https://github.com/php/php-src/tags)

