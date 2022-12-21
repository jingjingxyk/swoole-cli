

```shell
alpine  php postgresql

https://github.com/docker-library/php/issues/221


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


# use source php code
```shell

apk add  libxml2-dev
apk add sqlite-dev
apk add openssl-dev
apk add bzip2-dev
apk add curl-dev
apk add icu-dev
apk add oniguruma-dev
apk add readline-dev readline-static
apk add libxslt-dev
apk add libzip-dev

```

```shell

PKG_CONFIG_PATH='/usr/lib/pkgconfig:/usr/lib64/pkgconfig'
export PKG_CONFIG_PATH=/usr/openssl/lib64/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/bzip2/lib/pkgconfig:/usr/readline/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/icu/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:$PKG_CONFIG_PATH

export PKG_CONFIG_PATH=/usr/openssl/lib64/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/bzip2/lib/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/readline/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:$PKG_CONFIG_PATH

./configure --prefix=/tmp/php-static \
--disable-all \
--enable-bcmath \
--enable-pcntl \
--enable-filter \
--enable-session \
--enable-tokenizer \
--enable-mbstring \
--enable-ctype \
--enable-posix \
--enable-sockets \
--enable-pdo \
--enable-phar \
--enable-mysqlnd \
--enable-intl \
--enable-fileinfo \
--enable-dom \
--enable-xml \
--enable-simplexml \
--enable-xmlreader \
--enable-xmlwriter \
--with-libxml=/usr \
--with-pdo-mysql=mysqlnd \
--with-pdo-sqlite \
--with-sqlite3 \
--with-zlib \
--with-zip \
--with-curl=/usr/curl \
--with-iconv=/usr/libiconv \
--with-bz2=/usr/bzip2 \
--with-xsl=/usr/ \
--with-gmp=/usr/gmp \
--with-sodium \
--with-openssl=/usr/openssl \
--with-openssl-dir=/usr/openssl \
--with-readline=/usr/readline \
--enable-gd --with-jpeg=/usr --with-freetype=/usr \
--enable-redis \
--enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares  --with-openssl-dir=/usr/openssl  --with-brotli-dir=/usr/brotli \
--with-yaml=/usr/libyaml \
--enable-mongodb \
--enable-inotify \

make EXTRA_CFLAGS='-fno-ident -Xcompiler -march=nehalem -Xcompiler -mtune=haswell -Os' \
     EXTRA_LDFLAGS_PROGRAM='-all-static -fno-ident -L/usr/libiconv/lib -L/usr/openssl/lib64 -L/usr/gmp/lib -L/usr/bzip2/lib
     -L/usr/readline/lib -L/usr/curl/lib -L/usr/lib64 -L/usr/lib  ' -j $(nproc)

make EXTRA_CFLAGS=' -march=nehalem -Xcompiler -mtune=haswell -Os' \
     EXTRA_LDFLAGS_PROGRAM='-all-static -L/usr/lib64 -L/usr/lib  -L/usr/libiconv/lib -L/usr/openssl/lib64 -L/usr/gmp/lib -L/usr/bzip2/lib    -L/usr/readline/lib -L/usr/curl/lib -L/usr/libsodium/lib -L/usr/icu/lib -L/usr/cares/lib -L/usr/oniguruma/lib  ' -j $(nproc)

```

```shell

make EXTRA_LDFLAGS_PROGRAM='-all-static' -j $(nproc)


make EXTRA_CFLAGS=' -march=nehalem -Xcompiler -mtune=haswell -Os' \
     EXTRA_LDFLAGS_PROGRAM='-all-static' -j  $(nproc)


```

```shell

CXXFLAGS="-ggdb -pipe -Wall -pedantic -I/usr/include/readline5" \
CPPFLAGS="-I/usr/include/readline5" \
LDFLAGS="-L/usr/lib64/readline5" \

```
