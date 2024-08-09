# static-coturn

构建静态 coturn

## 构建命令

> 本项目 派生于 [swoole-cli](https://github.com/jingjingxyk/swoole-cli/)

> 代码与 jingjingxyk/swoole-cli 项目的 new_dev 分支的代码 保持一致

## 下载`static-coturn`发行版

- [https://github.com/jingjingxyk/build-static-coturn/releases](https://github.com/jingjingxyk/build-static-coturn/releases)

## 快速使用 静态编译的 coturn

```shell
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-coturn-runtime.sh?raw=true | bash

cp -f ./bin/runtime/coturn/etc/turnserver.conf.default ./bin/runtime/coturn/etc/turnserver.conf

./bin/runtime/coturn/bin/turnserver -c ./bin/runtime/coturn/etc/turnserver.conf

```

## 构建文档

- [linux 版构建文档](docs/linux.md)
- [macOS 版构建文档](docs/macOS.md)
- [构建选项文档](docs/options.md)
- [搭建依赖库镜像服务](sapi/download-box/README.md)
- [quickstart](sapi/quickstart/README.md)

## Clone

```shell

git clone -b main https://github.com/jingjingxyk/build-static-coturn.git

# 或者

git clone --recursive -b build-static-coturn  https://github.com/jingjingxyk/swoole-cli.git

```

## 构建命令

```bash

cd swoole-cli
php prepare.php +coturn
bash make-install-deps.sh
bash make.sh all-library
bash make.sh config
bash make.sh build
bash make.sh archive

```

## 构建参考

    https://github.com/coturn/coturn.git

## 授权协议

* `build-static-coturn` 使用了多个其他开源项目，请认真阅读自动生成的 `bin/LICENSE`
  文件中版权协议，遵守对应开源项目的 `LICENSE`
* `build-static-coturn`
  本身的软件源代码、文档等内容以 `Apache 2.0 LICENSE`+`SWOOLE-CLI LICENSE`
  作为双重授权协议，用户需要同时遵守 `Apache 2.0 LICENSE`和`SWOOLE-CLI LICENSE`
  所规定的条款

## SWOOLE-CLI LICENSE

* 对 `swoole-cli` 代码进行使用、修改、发布的新项目必须含有 `SWOOLE-CLI LICENSE`的全部内容
* 使用 `swoole-cli`代码重新发布为新项目或者产品时，项目或产品名称不得包含 `swoole` 单词
