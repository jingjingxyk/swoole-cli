

```shell
alpine  php postgresql

https://github.com/docker-library/php/issues/221


```
## 配置需要下载的库
```shell

apt-get install -y libpq-dev
apt-get install -y postgresql-server-dev-14

postgresql-client-common postgresql-common



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

export PKG_CONFIG_PATH=/usr/openssl/lib64/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/bzip2/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/icu/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/libzip/lib/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/cares/lib/pkgconfig:/usr/readline/lib/pkgconfig:/usr/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:$PKG_CONFIG_PATH


./configure --prefix=/tmp/php-static \
--with-curl=/usr/curl \
--with-iconv=/usr/libiconv \
--with-bz2=/usr/bzip2 \
--enable-bcmath \
--enable-pcntl \
--enable-filter \
--enable-session \
--enable-tokenizer \
--enable-mbstring \
--enable-ctype \
--with-zlib=/usr/zlib/ \
--with-zip \
--enable-posix \
--enable-sockets \
--enable-pdo \
--with-sqlite3=/usr/sqlite3 \
--enable-phar \
--enable-mysqlnd \
--enable-intl \
--enable-fileinfo \
--with-pdo-mysql=mysqlnd \
--with-pdo-sqlite \
--with-xsl=/usr/libxslt \
--with-gmp=/usr/gmp \
--with-openssl=/usr/openssl --with-openssl-dir=/usr/openssl \
--with-readline=/usr/readline \
--enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml=/usr/libxml2 \
--enable-mongodb \
--enable-inotify \

    make EXTRA_CFLAGS='-fno-ident -Xcompiler -march=nehalem -Xcompiler -mtune=haswell -Os' \
    EXTRA_LDFLAGS_PROGRAM='-all-static -fno-ident  -L/usr/libiconv/lib -L/usr/openssl/lib   -L/usr/gmp/lib  -L/usr/bzip2/lib  -L/usr/brotli/lib -L/usr/readline/lib  -L/usr/curl/lib -L/usr/mimalloc/lib -L/usr/lib -L/usr/lib64 '  -j $(nproc)

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

```shell

pkg-config --cflags readline


./configure --prefix=/usr/postgresql \
            --with-ssl=openssl  \
            --with-readline \
            --with-icu ICU_CFLAGS='-I/usr/icu/include' ICU_LIBS='-L/usr/icu/lib -licui18n -licuuc -licudata' \
            --with-includes='/usr/openssl/include/:/usr/readline/include' \
            --with-libraries='/usr/openssl/lib64:/usr/readline/lib'


```
