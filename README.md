# static-coturn

构建静态 coturn

## 构建命令

> 本项目 派生于 [swoole-cli](https://github.com/jingjingxyk/swoole-cli/)

> 代码与 swoole-cli 项目的 new_dev 分支的代码 保持一致

## 下载`static-coturn`发行版

- [https://github.com/jingjingxyk/build-static-coturn/releases](https://github.com/jingjingxyk/build-static-coturn/releases)

## `static-coturn`构建文档

- [linux 版构建文档](docs/linux.md)
- [macOS 版构建文档](docs/macOS.md)
- [windows Cygwin 版构建文档](docs/Cygwin.md)
- [windows WSL 版构建文档](docs/wsl.md)
- [php-cli 构建选项文档](docs/options.md)
- [php-cli 搭建依赖库镜像服务](sapi/download-box/README.md)
- [quickstart](sapi/quickstart/README.md)

## Clone

```shell

git clone -b main https://github.com/jingjingxyk/build-static-coturn.git

# 或者

git clone --recursive -b coturn  https://github.com/jingjingxyk/swoole-cli.git

```

## 快速准备 PHP 运行时

```shell
cd swoole-cli

bash setup-php-runtime.sh
# 或者
bash setup-php-runtime.sh --mirror china

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

> > > > > > > new_dev

```bash

    git clone -b new_dev https://github.com/jingjingxyk/swoole-cli/
    cd swoole-cli
    php prepare.php +coturn
    bash make-install-deps.sh
    bash make.sh all-library
    bash make.sh config
    bash make.sh build
    bash make.sh archive

```

## 构建 static-coturn

```shell
./make.sh build
```

> 编译成功后会生成`bin/coturn/turnserver`

## 打包

```shell
./make.sh archive
```

> 打包成功后会生成 `coturn-{version}-{os}-{arch}.tar.xz`
> 压缩包，包含 `turnserver` 可执行文件、`LICENSE` 授权协议文件。

## 授权协议

* `build-static-coturn` 使用了多个其他开源项目，请认真阅读自动生成的 `bin/LICENSE`
  文件中版权协议，遵守对应开源项目的 `LICENSE`
* `build-static-coturn`
  本身的软件源代码、文档等内容以 `Apache 2.0 LICENSE`+`SWOOLE-CLI LICENSE`
  作为双重授权协议，用户需要同时遵守 `Apache 2.0 LICENSE`和`SWOOLE-CLI LICENSE`
  所规定的条款

  https://github.com/coturn/coturn.git

