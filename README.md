# swoole-cli

> 说明：需要准备二个构建环境

## 编译阶段简述

1. 第一阶段构建环境用于生成构建脚本
2. 第二阶段构建环境用于静态编译本项目

## 下载扩展源码，下载扩展依赖库，并生成构建脚本

```shell
# 默认
php prepare.php

# 添加扩展
php prepare.php +inotify +mongodb
# 减少扩展
php prepare.php -opcache -gd -mongodb


```

* 脚本会自动下载相关的`C/C++`库以及`PECL`扩展
* 可使用`+{ext}`或者`-{ext}`增减扩展

## 使用容器进行构建说明

> 需要将 `swoole-cli` 的目录映射到容器的 `/work` 目录

## 静态编译 依赖库

```shell
./make.sh all-library
```

## 构建

> 编译成功后会生成`bin/swoole-cli`

```shell
# 编译静态PHP

./make.sh config
./make.sh build

```

## 打包

```shell
./make.sh archive
```

## 授权协议

* `swoole-cli`使用了多个其他开源项目，请认真阅读 [LICENSE](bin/LICENSE)
  文件中版权协议，遵守对应开源项目的`LICENSE`
* `swoole-cli`本身的软件源代码、文档等内容以`Apache 2.0 LICENSE`
  +`SWOOLE-CLI LICENSE`作为双重授权协议，用户需要同时遵守`Apache 2.0 LICENSE`
  和`SWOOLE-CLI LICENSE`所规定的条款

## SWOOLE-CLI LICENSE

* 对`swoole-cli`代码进行使用、修改、发布的新项目必须含有`SWOOLE-CLI LICENSE`的全部内容
* 使用`swoole-cli`代码重新发布为新项目或者产品时，项目或产品名称不得包含`swoole`
  单词

## download swoole-cli

- [swoole-cli](https://github.com/swoole/swoole-src/releases)
- [swoole-cli mirror1](https://github.com/swoole/swoole-src/releases)
- [swoole-cli mirror2](https://www.swoole.com/download)

## swoole-cli 参考文档

- [Swoole-Cli 5.0.1：PHP 的二进制发行版](https://zhuanlan.zhihu.com/p/581695339)
- [Swoole v5.0 版本新特性预览之新的运行模式](https://zhuanlan.zhihu.com/p/459983471)
- [Swoole-Cli 5.0.1 使用说明](https://wenda.swoole.com/detail/108876)
- [swoole wiki](https://wiki.swoole.com/#/)

## 在线构建产品

- [Code-Galaxy](https://code-galaxy.net/)