# 快速开始

## [linux 版](./linux/linux/README.md)

> `php prepare.php --with-build-type=dev +apcu +ds -gd -zip -imagick`
> gd 库 libXpm 编译不成功，libzip 需要降低版本 ，imagick 依赖libzip
> 需要重新编译curl ; php7.33 依赖库curl 不包含 nghttp2
> (curl 包含nghttp2 与 swoole 里面包含的 nghttp2 冲突，保留 swoole 内置的nghttp2)

## macos

# 快速初始化构建环境

## 准备PHP 运行时

```bash

# 准备PHP 运行时
bash sapi/quickstart/setup-php-runtime.sh

# 准备PHP 运行时 使用代理 （需提前准备好代理)
bash sapi/quickstart/setup-php-runtime.sh --proxy http://192.168.3.26:8015

# 准备PHP 运行时 使用镜像 （镜像源 https://www.swoole.com/download）
bash sapi/quickstart/setup-php-runtime.sh --mirror china

# 容器中准备运行时
bash sapi/quickstart/setup-php-runtime-in-docker.sh

php -v
compoer -v


```

## [linux 快速启动容器环境](linux/README.md)

## [linux](../../docs/linux.md)

## [windows cygwin](../../docs/Cygwin.md)

## [macos ](../../docs/macOS.md)



