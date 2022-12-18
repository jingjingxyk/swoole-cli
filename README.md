# swoole-cli

## 准备环境下载源码包环境
```shell

wget https://www.php.net/distributions/php-8.1.12.tar.gz
tar -zxvf php-8.1.12.tar.gz

git submodule update --init --recursive

test -d tmp && rm -rf tmp
mkdir -p tmp
rsync -avr --delete-before --stats --progress $(pwd)/ tmp/ \
  --exclude tmp/

docker run --rm --name swoole-cli-build-dev -v $(pwd)/tmp:/work -w /work -ti --init  docker.io/jingjingxyk/build-swoole-cli:alpine-edge-20221205T144525Z

export http_proxy=http://192.168.3.26:8015
export https_proxy=http://192.168.3.26:8015

pear config-set http_proxy $http_proxy
pear config-set http_proxy ""
docker exec -it swoole-cli-build-dev sh

ini_set('display_errors', '1');
error_reporting(-1);

$server->set(['enable_server_token' => true]);

# docker exec -i swoole-cli-build-dev php prepare.php +inotify +mongodb
# docker exec -i swoole-cli-build-dev sh -c "SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify"

```

## 配置需要下载的库
```shell

apt-get install -y libpq-dev
apt-get install -y postgresql-server-dev-14

postgresql-client-common postgresql-common

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib64/pkgconfig/


 pkg-config --cflags openssl

pkg-config --libs openssl


./configure --prefix=/usr/pgsql -lssl  -lcrypto  LDFLAGS="-static"
./configure --prefix=/usr/pgsql   LDFLAGS="-static"


./configure --prefix=/usr/pgsql LDFLAGS="-static" --with-ssl=openssl --with-includes=/usr/openssl/include/openssl:/usr/include  --with-libraries=/usr/openssl/lib64:/usr/lib
./configure --prefix=/usr/pgsql  --with-ssl=openssl --with-includes=/usr/openssl/include/openssl:/usr/include  --with-libraries=/usr/openssl/lib64:/usr/lib


https://wiki.postgresql.org/wiki/Compile_and_Install_from_source_code

libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache




apt install -y  libcrypto++-dev


-lcrypto -lssl

https://zhuanlan.zhihu.com/p/380937946

gcc -I -L -l区别

-I 寻找头文件的目录
-L 指定库的路径
-l 指定需连接的库名  -lpthread

-fPIC -shared

cmake -DCMAKE_CXX_FLAGS=-fPIC -DWITH_STDTHREADS=ON  -DCMAKE_BUILD_TYPE=Release ..





```
## 生成构建脚本

```shell
php prepare.php
php prepare.php +inotify +mongodb
```

* 脚本会自动下载相关的`C/C++`库以及`PECL`扩展
* 可使用`+{ext}`或者`-{ext}`增减扩展

## 进入 Docker Bash

```shell
./make.sh docker-bash
```

> 需要将 `swoole-cli` 的目录映射到容器的 `/work` 目录

## 编译配置

```shell

./make.sh all-library

./make.sh config


```

## 构建

```shell
./make.sh build
```

> 编译成功后会生成`bin/swoole-cli`

## 打包

```shell
./make.sh archive
```

## 授权协议

* `swoole-cli`使用了多个其他开源项目，请认真阅读 [LICENSE](bin/LICENSE) 文件中版权协议，遵守对应开源项目的`LICENSE`
* `swoole-cli`本身的软件源代码、文档等内容以`Apache 2.0 LICENSE`+`SWOOLE-CLI LICENSE`作为双重授权协议，用户需要同时遵守`Apache 2.0 LICENSE`和`SWOOLE-CLI LICENSE`所规定的条款

## SWOOLE-CLI LICENSE

* 对`swoole-cli`代码进行使用、修改、发布的新项目必须含有`SWOOLE-CLI LICENSE`的全部内容
* 使用`swoole-cli`代码重新发布为新项目或者产品时，项目或产品名称不得包含`swoole`单词
