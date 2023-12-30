# static-socat

构建静态 socat

## 实现原理

> 复用 [jingjingxyk/swoole-cli `new_dev`分支](https://github.com/jingjingxyk/swoole-cli/tree/new_dev) 的 静态库构建流程

## 构建命令

```bash

    git clone -b new_dev https://github.com/jingjingxyk/swoole-cli/
    cd swoole-cli
    php prepare.php +socat
    bash make-install-deps.sh
    bash make.sh all-library
    bash make.sh make_release_archive

```
