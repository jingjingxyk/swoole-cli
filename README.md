# build static aria2

构建静态 原生 aria2 运行时

## 说明

> 复用
> [jingjingxyk/swoole-cli](https://github.com/jingjingxyk/swoole-cli/tree/new_dev)
> 项目的 `new_dev`分支的静态库构建流程

> 本项目 只需要关注 `.github/workflow` 目录里配置文件的变更

## 下载`aria2`发行版

- [https://github.com/swoole/build-static-php/releases](https://github.com/swoole/build-static-php/releases)

## 立即使用 aria2

```shell

curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-aria2-runtime.sh?raw=true | bash

```

## 构建文档

- [linux 版构建文档](docs/linux.md)
- [macOS 版构建文档](docs/macOS.md)
- [构建选项文档](docs/options.md)
- [搭建依赖库镜像服务](sapi/download-box/README.md)
- [quickstart](sapi/quickstart/README.md)

## Clone

```shell

git clone -b build-static-aria2 https://github.com/jingjingxyk/swoole-cli.git build-static-aria2

# 或者

git clone -b main  https://github.com/jingjingxyk/build-static-aria2.git

```

## 构建命令

```bash

cd build-static-aria2
bash setup-php-runtime.sh
# 或者使用镜像
# 来自 https://www.swoole.com/download
bash setup-php-runtime.sh --mirror china
php prepare.php +aria2
bash make-install-deps.sh
bash make.sh all-library
bash make.sh config
bash make.sh build
bash make.sh archive



```

## 快速准备运行环境

### linux

如容器已经安装，可跳过执行安装 docker 命令

```bash

sh sapi/quickstart/linux/install-docker.sh
sh sapi/quickstart/linux/run-alpine-container.sh
sh sapi/quickstart/linux/connection-swoole-cli-alpine.sh
sh sapi/quickstart/linux/alpine-init.sh

# 使用镜像源安装
sh sapi/quickstart/linux/install-docker.sh --mirror china
sh sapi/quickstart/linux/alpine-init.sh --mirror china

```

### macos

如 homebrew 已安装，可跳过执行安装 homebrew 命令

```bash

bash sapi/quickstart/macos/install-homebrew.sh
bash sapi/quickstart/macos/macos-init.sh

# 使用镜像源安装
bash sapi/quickstart/macos/install-homebrew.sh --mirror china
bash sapi/quickstart/macos/macos-init.sh --mirror china

```

## 一条命令执行整个构建流程

```bash

cp build-release-example.sh build-release.sh

# 按你的需求修改配置  OPTIONS=" +aria2 "
vi build-release.sh

# 执行构建流程
bash build-release.sh


```

## 授权协议

* `build-static-aria2` 使用了多个其他开源项目，请认真阅读自动生成的 `bin/LICENSE`
  文件中版权协议，遵守对应开源项目的 `LICENSE`
* `build-static-aria2`本身的软件源代码、文档等内容以 `Apache 2.0 LICENSE`+`SWOOLE-CLI LICENSE`
  作为双重授权协议，用户需要同时遵守 `Apache 2.0 LICENSE`和`SWOOLE-CLI LICENSE`
  所规定的条款

## SWOOLE-CLI LICENSE

* 对 `swoole-cli` 代码进行使用、修改、发布的新项目必须含有 `SWOOLE-CLI LICENSE`的全部内容
* 使用 `swoole-cli`代码重新发布为新项目或者产品时，项目或产品名称不得包含 `swoole` 单词
