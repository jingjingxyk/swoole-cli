# 快速开始

## [linux 版](./linux/linux/README.md)

> `php prepare.php --with-build-type=dev +apcu +ds -gd -zip -imagick`
> gd 库 libXpm 编译不成功，libzip 需要降低版本 ，imagick 依赖libzip
> 需要重新编译curl ; php7.33 依赖库curl 不包含 nghttp2
> (curl 包含nghttp2 与 swoole 里面包含的 nghttp2 冲突，保留 swoole 内置的nghttp2)

## macos

# 快速初始化构建环境

## 一个脚本执行整个构建流程

> 定制 build-release.sh 即可开始构建

```bash

  cp  build-release-example.sh  build-release.sh

  bash build-release.sh

```

## 准备 PHP 运行时

```bash

# 准备 PHP 运行时
bash sapi/quickstart/setup-php-runtime.sh

# 准备PHP 运行时 使用代理
bash sapi/quickstart/setup-php-runtime.sh --proxy http://192.168.3.26:8015

# 准备PHP 运行时 使用镜像 （镜像源 https://www.swoole.com/download）
bash sapi/quickstart/setup-php-runtime.sh --mirror china

# 容器内准备 PHP 运行时
bash sapi/quickstart/setup-php-runtime-in-docker.sh

# 验证
php -v
composer -v

```

## 准备依赖库源码

```bash
# 源码来源 https://github.com/swoole/swoole-cli/releases/download/${TAG}/all-deps.zip

bash sapi/download-box/download-box-get-archive-from-server.sh

```

## 准备运行环境 (linux/macos/windows)

1. [ linux 快速启动 容器 构建环环境 ](linux/README.md)
1. [ windows cygwin 快速启动 构建环环境 ](windows/README.md)
1. [ macos 快速启动 构建环环境 ](macos/README.md)
1. [ 构建选项 ](../../docs/options.md)

## 构建依赖库 、构建swoole 、打包

```bash

# 构建所有依赖库
bash make.sh all-library

bash make.sh config
bash make.sh build
bash make.sh archive

```

## 更多构建参考文档

1. [cygwin](../../docs/Cygwin.md)
1. [linux](../../docs/linux.md)
1. [macos](../../docs/macOS.md)
1. [wsl](../../docs/wsl.md)
1. [构建选项](../../docs/options.md)

## PHP 版本变更详情

1. [PHP 8.1.x 升级到 PHP 8.2.x  的变更](https://www.php.net/manual/zh/migration82.php)
1. [PHP 8.0.x 升级到 PHP 8.1.x  的变更](https://www.php.net/manual/zh/migration81.php)
1. [PHP 7.4.x 升级到 PHP 8.0.x  的变更](https://www.php.net/manual/zh/migration80.php)

## [PHP 版本查看](https://github.com/php/php-src/tags)

