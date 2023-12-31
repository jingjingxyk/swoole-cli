# static-privoxy

构建静态 privoxy

## 构建命令

>
复用 [jingjingxyk/swoole-cli](https://github.com/jingjingxyk/swoole-cli/tree/new_dev) `new_dev`
分支 的 静态库构建流程

>
本项目与[jingjingxyk/swoole-cli](https://github.com/jingjingxyk/swoole-cli/tree/new_dev) `new_dev`
分支的区别就是 `[.github/workflow](./.github/workflow)` 配置

```bash

    git clone -b new_dev https://github.com/jingjingxyk/swoole-cli/
    cd swoole-cli
    php prepare.php +privoxy
    bash make-install-deps.sh
    bash make.sh all-library
    bash make.sh config

```

## privoxy 源码构建参考

    https://www.privoxy.org
