
```shell

sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
apk update

apk add icu icu-dev icu-libs icu-data-full icu-static
apk add ncurses-dev ncurses-libs ncurses-static
apk add readline readline-dev readline-static

apk add libidn2 libidn2-dev  libidn2-static
apk add nghttp2-dev nghttp2-libs nghttp2-static
apk add brotli-dev brotli-libs brotli-static

apk add oniguruma oniguruma-dev



sh make.sh cares



```

```shell

pkg-config --list-all
pkg-config --list-all --static
pkg-config --libs libsodium --static

pkg-config --define-prefix --static --libs libcurl

pkg-config --cflags --libs libzip
pkg-config --cflags --libs libsodium

pkg-config --cflags  libzip
pkg-config --libs  libzip



```


```shell
alpine  php postgresql

https://github.com/docker-library/php/issues/221


GNU soft
https://www.gnu.org/software/


```
## 配置需要下载的库
```shell

apt-get install -y libpq-dev


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

apk add libxml2-dev
apk add sqlite-dev
apk add openssl-dev
apk add bzip2-dev
apk add curl-dev
apk add icu-dev
apk add oniguruma-dev
apk add readline-dev readline-static
apk add libxslt-dev
apk add libzip-dev








add pcre2-dev re2c libbz2
apk add c-ares c-ares-dev

apk add libzip libzip-dev libzip-tools
apk add bzip2 bzip2-dev bzip2-static

apk --no-cache add postgresql-libs libpq-dev postgresql
apk add libbson libbson-dev libbson-static








sh make.sh icu
sh make.sh bzip2

sh make.sh readline

```



```shell

CFLAGS=-Wno-dev
CXXFLAGS="-ggdb -pipe -Wall -pedantic -I/usr/include/readline5" \
CPPFLAGS="-I/usr/include/readline5" \
LDFLAGS="-L/usr/lib64/readline5" \

```

```shell

https://people.freedesktop.org/~dbn/pkg-config-guide.html

PKG_CONFIG_PATH='/usr/lib/pkgconfig:/usr/lib64/pkgconfig'

export PKG_CONFIG_PATH="/usr/readline/lib/pkgconfig:/usr/ncurses/lib/pkgconfig:$PKG_CONFIG_PATH"

export PKG_CONFIG_PATH="/usr/cares/lib/pkgconfig:$PKG_CONFIG_PATH"
# readline-dev

pkg-config --libs --static pkg-config --libs --static
pkg-config --list-all

pkg-config --cflags --libs libzip
pkg-config --libs --cflags libzip
pkg-config --libs  libzip

pkg-config --cflags --libs zlib liblzma liblzma

pkg-config --cflags --libs ncurses readline
pkg-config --libs  ncurses readline
pkg-config --cflags --libs  freetype2
pkg-config --cflags --libs  libbrotlidec
pkg-config --cflags --libs  oniguruma
pkg-config --cflags --libs  libsodium



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
pkg-config --cflags --libs icu-io
pkg-config --cflags --libs iconv
pkg-config --cflags --libs libzip
pkg-config --cflags --libs zlib
pkg-config --cflags --libs liblzma
pkg-config --cflags --libs libcares

pkg-config --cflags --libs libzip
pkg-config --cflags --libs libxml-2.0
pkg-config --cflags --libs libxslt
pkg-config --cflags --libs icu-i18n icu-io icu-io
pkg-config --cflags --libs icu-i18n icu-io icu-io libxml-2.0 libxslt
pkg-config  --libs icu-i18n icu-io icu-io libxml-2.0 libxslt

pkg-config  --libs oniguruma
pkg-config  --cflags oniguruma

find / -name pkgconfig

locate readline.pc

-DNCURSES_WIDECHA

--with-openssl-includes=/usr/local/include and --with-openssl-libraries=/usr/local/li

CFLAGS=-static
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

pecl install -D 'enable-sockets="no" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="no" enable-swoole-curl="yes" enable-cares="yes"' https://pecl.php.net/get/swoole-4.4.26.tgz


```

```shell
# statically compiling libpq on Alpine.
# https://bugfactory.io/blog/portability-via-static-linking-of-libpq/



apk --no-cache add postgresql-libs libpq-dev postgresql

apk --no-cache add postgresql-dev build-base

ldd /usr/lib/libpq.so



export PKG_CONFIG_PATH="/usr/openssl/lib64/pkgconfig:/usr/lib/pkgconfig"
pkg-config --cflags --libs libpq
pkg-config --libs libpq


gcc -static -o test-libpg test-libpg.c -lpq
gcc -static -o test-libpg test-libpg.c -lpq -lssl -lcrypto

gcc -static -o test-libpg test-libpg.c `pkg-config --cflags --libs libpq`
gcc  -o test-libpg test-libpg.c `pkg-config --cflags --libs libpq`
ldd  test-libpg

ldd test-libpg



-lpq -lpgport -lpgcommon

ibpgcommon 和 libpqport

```
