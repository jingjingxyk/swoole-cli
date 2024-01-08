# static-coturn

构建静态 coturn

## 构建命令

> 复用
> [jingjingxyk/swoole-cli](https://github.com/jingjingxyk/swoole-cli/tree/new_dev)
> 项目的 `new_dev`分支的静态库构建流程

> 本项目 只需要关注 `.github/workflow` 目录里配置文件的变更

```bash

    git clone -b new_dev https://github.com/jingjingxyk/swoole-cli/
    cd swoole-cli
    php prepare.php +coturn
    bash make-install-deps.sh
    bash make.sh all-library
    bash make.sh config

```

## coturn 源码构建参考

    https://github.com/coturn/coturn.git

