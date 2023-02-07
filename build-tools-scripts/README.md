```shell

sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
apk update

# 编译 ncurses 和 readline 非标准目录，木有没成功
apk add --no-cache  ncurses-dev ncurses-libs ncurses-static
apk add --no-cache  readline-dev readline-static
# apk add --no-cache  readline readline-dev readline-static
apk del  ncurses-dev ncurses-libs ncurses-static  readline-dev readline-static

apk add --no-cache icu icu-dev icu-libs icu-data-full icu-static
# swoole 需要
apk add --no-cache  c-ares c-ares-dev c-ares-utils
#apk add --no-cache  c-ares c-ares-dev c-ares-utils


# meson 和ninja 构建
apk add python3 python3-dev py3-pip ninja bazel
pip3 install meson  -i https://pypi.tuna.tsinghua.edu.cn/simple

# https://github.com/bazelbuild/bazel/releases
curl -Lo bazel-6.0.0-linux-x86_64 --connect-timeout 15 --retry 5 --retry-delay 5  https://github.com/bazelbuild/bazel/releases/download/6.0.0/bazel-6.0.0-linux-x86_64
mv bazel-6.0.0-linux-x86_64 /usr/bin/bazel
chmod a+x /usr/bin/bazel


# 代码比较
apk add meld

apk add --no-cache icu icu-dev icu-libs icu-data-full icu-static
apk add --no-cache  bzip2 bzip2-dev bzip2-static
apk add libzip libzip-dev libzip-tools
apk add --no-cache  zstd zstd-dev zstd-libs
apk add --no-cache  xz xz-dev xz-libs
apk add libidn2 libidn2-dev  libidn2-static
apk add nghttp2-dev nghttp2-libs nghttp2-static
apk add brotli-dev brotli-libs brotli-static


sh make.sh zip
sh make.sh cares

# 为 postgresql 准备
apk add libxml2-dev libxml2-static

apk add brotli-dev brotli-libs brotli-static
apk add oniguruma oniguruma-dev

pkg-config --cflags ncursesw ncurses
pkg-config  --libs ncursesw ncurses

pkg-config --cflags  readline
pkg-config  --libs readline






```

```text

##  linux编译参数CPPFLAGS、CFLAGS、LDFLAGS参数的理解
https://blog.csdn.net/lailaiquququ11/article/details/126691913

CPPFLAGS : 预处理器需要的选项 如：-I (大写i指定头文件路径)
CFLAGS：编译的时候使用的参数 –Wall –g -c
LDFLAGS ：链接库使用的选项 –L -l (大写L指定动态库的路径，小写L指定动态库的名称)


# gcc常用的编译选项介绍
  https://blog.csdn.net/u011069498/article/details/105344865

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
pkg-config --libs  bzip2
pkg-config --libs  bz2



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

LIBS="L/usr/lib/llvm14/lib -lpgcommon -lpgport -lm"

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


-fPIC -DPIC


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
CXXFLAGS="-ggdb -pipe -Wall -pedantic -I/usr/include/readline5"
CPPFLAGS="-I/usr/include/readline5"
LDFLAGS="-L/usr/lib64/readline5"

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



您可以选择哪些库:
被静态链接: -Wl,-static
被动态链接: -Wl,-Bdynamic
```

```text
扩展模块  pecl  PECL(PHP Extension Community Library)：php的标准扩展库。
PEAR(PHP Extension and Application Repository)：php的扩展以及应用资源库。
https://zhuanlan.zhihu.com/p/434787317
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

## php 代码工具

- [php-code-sniffer](https://www.jetbrains.com/help/phpstorm/using-php-code-sniffer.html)
- [friendsofphp/php-cs-fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer)
  [phpstan](https://phpstan.org/user-guide/getting-started)
  [psalm](https://github.com/vimeo/psalm.git)
- [PHP_CodeSniffer](https://pear.php.net/package/PHP_CodeSniffer/docs)
- [php codesniffer,PHP 系列：代码规范之 Code Sniffer](https://blog.csdn.net/weixin_36433730/article/details/115228916)
- [symfony](https://github.com/symfony/symfony)
- [composer.phar](https://developer.aliyun.com/composer)
- [composer](https://getcomposer.org/doc/)
- [EditorConfig](https://editorconfig.org/)
- [PSR](https://www.php-fig.org/psr/)
- [phpunit](https://github.com/sebastianbergmann/phpunit.git)
- [Compiling PECL extensions statically into PHP](https://www.php.net/manual/en/install.pecl.static.php)
- [static-php-cli](https://github.com/crazywhalecc/static-php-cli/blob/master/README-en.md)
- [WebAssembly](https://pecl.php.net/package/wasm)
- [wasmer-php](https://github.com/wasmerio/wasmer-php)

> PHP_CodeSniffer 是一个代码风格检测工具。它包含两类脚本，phpcs 和 phpcbf(GitHub地址)。


```shell

pear install PHP_CodeSniffer-3.7.1
# wget pear.php.net/PHP_CodeSniffer-3.7.1

composer global require "squizlabs/php_codesniffer=*"
composer  require "squizlabs/php_codesniffer=*"

pear list
```

- [gnu mirro](https://mirrors.aliyun.com/gnu/)
  //git clone https://android.googlesource.com/platform/external/bzip2 -b master
  //git clone https://chromium.googlesource.com/external/github.com/nmoinvaz/minizip
  //https://chromium.googlesource.com/?format=HTML ;search "external/github.com/"

命令 nm 和 strip  属于Binutils工具集

连接选项： 链接选项 -rdynamic与动态符号表

显示可执行程序文件内的动态符号（注意，仅仅是动态符号）：

readelf -Ds a.out


编译时使用 -g，使可执行程序中包含调试信息；
最好不要使用 strip 去除可执行程序的符号信息，否则会看不到栈中的函数名称。

nm -A /usr/pgsql/lib/libpq.a |  grep -i 
nm -A /usr/openssl/lib64/libssl.a  |  grep -i toul

ar 命令用于更新，维护管理静态库。

ranlib 命令用于 更新库的符号索引表。

```text
    // "Core",
        'ctype',
        // "date",
        // "dom",
        'fileinfo',
        'filter',
        // "hash",
        'iconv',
        // "json",
        // "libxml",
        // "pcre",
        // "PDO",
        'pdo',
        'pdo_sqlite',
        // "Phar",
        'phar',
        'posix',
        // "Reflection",
        // "reflection",
        'session',
        // "SimpleXML",
        // "SPL",
        'sqlite3',
        // "standard",
        'tokenizer',
        'xml',
        // "xmlreader",
        // "xmlwriter",

        'opcache',
        'curl',
        'bz2',
        'bcmath',
        'pcntl',
        'tokenizer', // composer 要求
        'mbstring',  // 依赖 oniguruma
        'zlib',
        'zip',
        'sockets',
        'mysqlnd',
        'mysqli',
        'intl',  // 依赖 ICU, 安装ICU 需要python3
        'pdo_mysql',
        // 'pdo_pgsql',
        'soap',
        'xsl',
        'gmp',
        'exif',
        'sodium',
        'openssl',
        'readline',
        'gd', //freetype 依赖 libbrotlidec
        'redis',
        // 'pgsql',
        'swoole',
        'yaml',
        'imagick',
        'mongodb', //依赖 openssl zlib  ICU
        'ds'



    bzip2 没有 libbz2.pc 文件，不能使用 pkg-config 命令，使用时需要手动指定
    libiconv 不能使用 pkg-config 命令
    扩展 mbstring 依赖库oniguruma
    扩展 intl 依赖库 ICU
    扩展 gd 依赖库 freetype , freetype 依赖 zlib bzip2 libpng  brotli
    扩展'mongodb', 依赖库 openssl, zlib等
    扩展 curl 依赖 openssl
    扩展 zip 依赖 openssl

```

词法（Lexical structure ）
语法（Syntactic structure）
语义（Semantics）

语言是有一定的语法规则的（grammar）。而grammar是一组有限的规则的集合


```makefile
override CFLAGS += $(shell pkg-config --cflags ncursesw) \
                   -std=gnu11 \
                   -Wall \
                   -Wextra \
                   -Wmissing-declarations \
                   -Wno-sign-compare \
                   -Wno-unused-parameter \
                   -Wredundant-decls \
                   -Wstrict-prototypes

override LDLIBS += -lreadline \
                   $(shell pkg-config --libs-only-l ncursesw)

override LDFLAGS += $(shell pkg-config --libs-only-L --libs-only-other ncursesw)

```


```shell
# https://github.com/swoole/swoole-src/issues/4946

#  SWOOLE_CFLAGS="$SWOOLE_CFLAGS $LIBPQ_CFLAGS"
#  SWOOLE_PGSQL_CFLAGS="$SWOOLE_CFLAGS $LIBPQ_CFLAGS"


phpize &&
export LIBPQ_CFLAGS="-I/usr/local/libpq/15.1/include" &&
export LIBPQ_LIBS="-L/usr/local/libpq/15.1/lib" &&
./configure --with-openssl-dir=/usr/openssl --enable-swoole-pgsql &&
make && make install
```

```text

brotli-libs
nghttp2-libs

```


```shell

# 创建空分支

gir checkout  --orphan new_branch
git rm -rf .


```

```shell
wget http://pear.php.net/go-pear.phar
$ php go-pear.phar

```

```shell
php -c /path/to/php.ini -r 'echo get_include_path()."\n";'

```

## static compile libpq
> https://www.postgresql.org/message-id/CABFfbXuxyO20JN8T%2BCyfSe29T-GTON69FrKHQ%3Dc9jDMxnm6C_w%40mail.gmail.com
```shell
libpq.a: $(OBJS)
  ar rcs $@ $^

cat >>  src/interfaces/libpq/Makefile <<EOF

libpq.a: $(OBJS)
  ar rcs $@ $^

EOF

 $(AR) $@ $(LIBXXX) $(ARFLAGS) 
        $(RANLIB) $@
        
```

```shell

https://github.com/swoole/swoole-src/issues/4833#issuecomment-1253146715

USE_ZEND_ALLOC=0 valgrind php your_file.php

# https://github.com/swoole/swoole-src/issues/4854#issuecomment-1312298196
export USE_ZEND_ALLOC=0 && LD_PRELOAD=/usr/local/lib/libjemalloc.so

strace -p

https://github.com/swoole/swoole-src/issues/4818#issuecomment-1240391101
gdb attach 31626
```



```shell

intl 

 --with-icu-dir
# https://www.php.net/manual/en/book.intl.php#book.intl
LD_LIBRARY_PATH

```

### 参考
1. [lwmbs](https://github.com/dixyes/lwmbs)
1. [static-php-cli](https://github.com/crazywhalecc/static-php-cli.git)
1. [bash 编写参考](https://github.com/symfony-cli/symfony-cli/blob/main/installer/bash-installer)
1. [symfony-cli](https://github.com/symfony-cli)
1. [symfony](https://github.com/symfony/symfony)
1. [Swoole v5.0 版本新特性预览之新的运行模式](https://zhuanlan.zhihu.com/p/459983471)
1. [Swoole-Cli 5.0.1：PHP 的二进制发行版](https://zhuanlan.zhihu.com/p/581695339)
1. [nm 简明教程](https://zhuanlan.zhihu.com/p/501339114)


```text
fe-connect

common 
port 
ecpg 
backend/libpq
include/libpq 



```