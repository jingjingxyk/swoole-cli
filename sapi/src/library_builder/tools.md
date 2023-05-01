

## git 删除子模块
```bash
git submodule deinit ext/swoole


# 删除所有未跟踪的文件，谨慎使用，删除了，可就找不回来了
git clean -df

```

## 只克隆指定分支最近一次commit
```bash

git clone --depth=1 --single-branch https://github.com/jingjingxyk/swoole-cli

```


## 去除 commit 合并 分支
```bash

git merge --squash


```

## 创建空分支
```bash

git checkout  --orphan  new_branch_name

git rm -rf .


```
