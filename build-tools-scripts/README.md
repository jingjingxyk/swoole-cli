

```shell
alpine  php postgresql

https://github.com/docker-library/php/issues/221


GNU soft
https://www.gnu.org/software/


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
export PKG_CONFIG_PATH="/usr/libxml2/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/openssl/lib64/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/curl/lib/pkgconfig:$PKG_CONFIG_PATH"

./configure \
--enable-ctype \
--enable-fileinfo \
--enable-filter \
--with-iconv=/usr/libiconv \
--with-pdo-sqlite \
--enable-posix \
--enable-session \
--with-sqlite3=/usr/sqlite3 \
--enable-tokenizer \
--enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml=/usr/libxml2 \
--with-curl=/usr/curl \
--with-bz2=/usr/bzip2 \
--enable-bcmath \
--enable-pcntl \
--enable-tokenizer \
--enable-mbstring \
--with-zlib=/usr/zlib/ \
--enable-sockets \
--enable-phar \
--enable-mysqlnd \
--enable-intl \
--with-pdo-mysql=mysqlnd \
--with-xsl=/usr/libxslt \
--with-gmp=/usr/gmp \
--with-openssl=/usr/openssl --with-openssl-dir=/usr/openssl \
--enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml=/usr/libxml2


 make EXTRA_CFLAGS='-fno-ident -Xcompiler -march=nehalem -Xcompiler -mtune=haswell -Os' \
    EXTRA_LDFLAGS_PROGRAM='-all-static -fno-ident  -L/usr/libiconv/lib -L/usr/openssl/lib64 -L/usr/libxml2/lib -L/usr/libxslt/lib -L/usr/gmp/lib -L/usr/zlib/lib -L/usr/bzip2/lib -L/usr/libzip/lib -L/usr/sqlite3/lib -L/usr/icu/lib -L/usr/oniguruma/lib -L/usr/brotli/lib -L/usr/cares/lib -L/usr/ncurses/lib -L/usr/readline/lib -L/usr/curl/lib -L/usr/libsodium/lib -L/usr/libyaml/lib -L/usr/mimalloc/lib '  -j 8
```

```shell

make EXTRA_LDFLAGS_PROGRAM='-all-static' -j $(nproc)


make EXTRA_CFLAGS=' -march=nehalem -Xcompiler -mtune=haswell -Os' \
     EXTRA_LDFLAGS_PROGRAM='-all-static' -j  $(nproc)


```

```shell

CFLAGS=-Wno-dev
CXXFLAGS="-ggdb -pipe -Wall -pedantic -I/usr/include/readline5" \
CPPFLAGS="-I/usr/include/readline5" \
LDFLAGS="-L/usr/lib64/readline5" \

```

```shell




# readline-dev

 pkg-config --list-all
pkg-config --cflags --libs libzip
pkg-config --cflags --libs zlib liblzma liblzma

pkg-config --cflags --libs ncurses readline
pkg-config --libs  ncurses readline

pkg-config --cflags ncurses
pkg-config --cflags readline
pkg-config --cflags --libs readline
pkg-config --cflags --libs ncurses
pkg-config --cflags --libs sqlite3
pkg-config --cflags --libs openssl
pkg-config --cflags --libs libssl
pkg-config --cflags --libs libcrypto
pkg-config --cflags --libs icu-i18n
pkg-config --cflags --libs icu-io
pkg-config --cflags --libs icu-uc
pkg-config --cflags --libs iconv
pkg-config --cflags --libs libzip
pkg-config --cflags --libs zlib
pkg-config --cflags --libs liblzma

find / -name pkgconfig

locate readline.pc

-DNCURSES_WIDECHA


LDFLAGS=-L/usr/local/opt/libiconv/lib CPPFLAGS=-L/usr/local/opt/libiconv/include
CFLAGS=-I/usr/icu/include LDFLAGS=-L/usr/icu/lib
./configure --prefix=/usr/postgresql \
            --with-ssl=openssl  \
            --with-readline \
            --with-icu ICU_CFLAGS='-I/usr/icu/include' ICU_LIBS='-L/usr/icu/lib -licui18n -licuuc -licudata' \
            --with-includes='/usr/openssl/include/:/usr/readline/include' \
            --with-libraries='/usr/openssl/lib64:/usr/readline/lib'


```

```shell
export PKG_CONFIG_PATH="/usr/libxml2/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:$PKG_CONFIG_PATH"
./configure --prefix=/tmp/php --with-iconv=/usr/libiconv

make     EXTRA_LDFLAGS_PROGRAM='-all-static -L/usr/libiconv/lib -L/usr/libxml2/lib -L/usr/sqlite3/lib' -j  $(nproc)



```
