#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

cd ${__DIR__}


PKG_CONFIG_PATH='/usr/lib/pkgconfig'
test -d /usr/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/lib64/pkgconfig:$PKG_CONFIG_PATH" ;
test -d /usr/local/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH" ;
test -d /usr/local/lib/pkgconfig/ && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH" ;


cpu_nums=`nproc 2> /dev/null || sysctl -n hw.ncpu`
# `grep "processor" /proc/cpuinfo | sort -u | wc -l`

export PATH=/usr/pgsql/bin/:/usr/libffi/bin/:$PATH
export ORIGIN_PATH=$PATH


export CC=clang
export CXX=clang++
export LD=ld.lld
export PKG_CONFIG_PATH=/usr/openssl/lib/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/cares/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/ncurses/lib/pkgconfig:/usr/readline/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/bzip2/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/liblz4/lib/pkgconfig:/usr/liblzma/lib/pkgconfig:/usr/libzstd/lib/pkgconfig:/usr/libzip/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/icu/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:/usr/libjpeg/lib64/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/imagemagick/lib/pkgconfig:/usr/libidn2/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/pgsql/lib/pkgconfig:/usr/libffi/lib/pkgconfig:$PKG_CONFIG_PATH



version=$(cat version.txt)
# php 7.4 不支持 openssl 3 版本，请使用openssl 1 版本

mkdir -p build
cd build

test -d php-src && rm -rf php-src
mkdir -p php-src/
tar --strip-components=1 -C php-src/ -xf ${__DIR__}/download/${version}.tar.gz

cd php-src/

install_prefix_dir="/tmp/${version}"

mkdir -p $install_prefix_dir

mkdir -p ext/redis
mkdir -p ext/mongodb
mkdir -p ext/yaml
mkdir -p ext/apcu

test -d ext/swoole && rm -rf ext/swoole
cp -rf ${__DIR__}/download/swoole-src ext/swoole

tar --strip-components=1 -C ext/redis -xf ${__DIR__}/download/redis-5.3.7.tgz
tar --strip-components=1 -C ext/mongodb -xf ${__DIR__}/download/mongodb-1.15.0.tgz
tar --strip-components=1 -C ext/yaml -xf ${__DIR__}/download/yaml-2.2.2.tgz
tar --strip-components=1 -C ext/apcu -xf ${__DIR__}/download/apcu-5.1.22.tgz


# cp -f ext/openssl/config0.m4 ext/openssl/config.m4

:<<EOF
    LIBXML_CFLAGS=$(pkg-config --cflags libxml-2.0) ;
    LIBXML_LIBS=$(pkg-config --libs libxml-2.0) ;

    OPENSSL_CFLAGS=$(pkg-config --cflags openssl libcrypto libssl) ;
    OPENSSL_LIBS=$(pkg-config --libs openssl libcrypto libssl) ;

    SQLITE_CFLAGS=$(pkg-config --cflags sqlite3) ;
    SQLITE_LIBS=$(pkg-config --libs sqlite3) ;

    ZLIB_CFLAGS=$(pkg-config --cflags  zlib) ;
    ZLIB_LIBS=$(pkg-config --libs  zlib) ;

    CURL_CFLAGS=$(pkg-config --cflags libcurl) ;
    CURL_LIBS=$(pkg-config --libs libcurl) ;

    PNG_CFLAGS=$(pkg-config --cflags  libpng) ;
    PNG_LIBS=$(pkg-config --libs  libpng) ;

    WEBP_CFLAGS=$(pkg-config --cflags libwebp) ;
    WEBP_LIBS=$(pkg-config --libs libwebp) ;

    FREETYPE2_CFLAGS=$(pkg-config --cflags freetype2) ;
    FREETYPE2_LIBS=$(pkg-config --libs freetype2) ;

EOF




:<<EOF
CXX=$(icu-config --cxx)

CPPFLAGS=$(icu-config --cppflags)

CXXFLAGS=$(icu-config --cxxflags)

LDFLAGS=$(icu-config --ldflags)

EOF


:<<EOF

# https://unicode-org.github.io/icu/userguide/icu/howtouseicu.html

export PATH=/usr/c-ares/bin/:/usr/pgsql/bin/:/usr/libffi/bin/:/usr/icu_2/bin/:$PATH


CC=$(icu-config --cc)

CXX=$(icu-config --cxx)

CPPFLAGS=$(icu-config --cppflags)

CXXFLAGS=$(icu-config --cxxflags)

LDFLAGS =$(icu-config --ldflags)


export  CXXFLAGS=$(/usr/icu_2/bin/icu-config --cxxflags)
export  ICU_CFLAGS=$(/usr/icu_2/bin/icu-config --cppflags-searchpath)  ;
export  ICU_LIBS=$(/usr/icu_2/bin/icu-config --ldflags --ldflags-icuio)  ;

CFLAGS=-I/usr/icu_2/include LDFLAGS=-L/usr/icu_2/lib

icu-config --cxx --cxxflags --cppflags --ldflags -o sample sample.cpp

EOF

:<<EOF
export  ICU_CFLAGS=$(pkg-config --cflags --static icu-uc icu-io icu-i18n)  ;
export  ICU_LIBS=$(pkg-config  --libs --static icu-uc icu-io icu-i18n)  ;

export   ONIG_CFLAGS=$(pkg-config --cflags oniguruma) ;
export   ONIG_LIBS=$(pkg-config --libs oniguruma) ;

export   LIBSODIUM_CFLAGS=$(pkg-config --cflags libsodium) ;
export   LIBSODIUM_LIBS=$(pkg-config --libs libsodium) ;

export   XSL_CFLAGS=$(pkg-config --cflags libxslt) ;
export   XSL_LIBS=$(pkg-config --libs libxslt) ;

export   EXSLT_CFLAGS=$(pkg-config --cflags libexslt) ;
export   EXSLT_LIBS=$(pkg-config --libs libexslt) ;


export   LIBZIP_CFLAGS=$(pkg-config --cflags libzip) ;
export   LIBZIP_LIBS=$(pkg-config --libs libzip) ;

export   LIBPQ_CFLAGS=$(pkg-config  --cflags --static      libpq)

export   LIBPQ_LIBS=$(pkg-config  --libs  --static       libpq)
EOF

# export CPPFLAGS=$(pkg-config  --cflags --static  libpq ncurses readline libcares libffi)
# export LIBS=$(pkg-config  --libs --static   libpq ncurses readline libcares libffi)
# export CPPFLAGS=$(pkg-config  --cflags --static  libpq ncurses readline libcares libffi)


# export CPPFLAGS="$CPPFLAGS -I/usr/include"

LIBS=$(pkg-config  --libs --static    libcares libpq libffi icu-uc icu-io icu-i18n)
export LIBS="$LIBS -L/usr/lib -lstdc++"

# which icu-config
# export CXXFLAGS=$(icu-config --cxxflags)
# export LDFLAGS=$(icu-config --ldflags)

:<<'EOF'
# export   NCURSES_CFLAGS=$(pkg-config --cflags formw  menuw  ncursesw panelw);
# export   NCURSES_LIBS=$(pkg-config  --libs formw  menuw  ncursesw panelw);

# export   READLINE_CFLAGS=$(pkg-config --cflags  readline)  ;
# export   READLINE_LIBS=$(pkg-config  --libs readline)  ;
EOF

# export 'CXXFLAGS=-std=c++11 '

test -f ./configure && rm ./configure ;

./buildconf --force ;

./configure --help



./configure LDFLAGS=-static --prefix=$install_prefix_dir \
    --disable-all \
    --enable-shared=no \
    --enable-static=yes \
    --disable-cgi \
    --disable-phpdbg \
    --enable-ctype \
    --enable-fileinfo \
    --enable-filter \
    --enable-json \
    --enable-pdo \
    --enable-phar \
    --enable-posix \
    --enable-session \
    --enable-tokenizer \
    --with-iconv=/usr/libiconv \
    --enable-mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite \
    --with-sqlite3=/usr/sqlite3 \
    --enable-dom \
    --enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml=/usr/libxml2 \
    --with-curl=/usr/curl \
    --with-bz2=/usr/bzip2 \
    --with-zlib=/usr/zlib/ \
    --with-zip=/usr/zip/ \
    --enable-bcmath \
    --enable-pcntl \
    --enable-mbstring \
    --enable-sockets \
    --with-pdo-mysql=mysqlnd \
    --with-xsl=/usr/libxslt \
    --with-gmp=/usr/gmp \
    --with-sodium=/usr/libsodium \
    --with-readline \
    --with-openssl --with-openssl-dir=/usr/openssl \
    --with-brotli-dir=/usr/brotli/ \
    --with-yaml=/usr/libyaml \
    --enable-swoole  --enable-swoole-curl  --enable-http2 --enable-swoole-json \
    --enable-redis \
    --enable-apcu \
    --with-ffi=/usr/libffi \
    --enable-opcache \
    --enable-intl \
    --enable-mongodb \
    --with-pgsql=/usr/pgsql --with-pdo-pgsql=/usr/pgsql \
    --enable-gd --with-jpeg=/usr/libjpeg/ --with-freetype=/usr/freetype --with-webp=/usr/libwebp \



sed -ie 's/-export-dynamic//g' "Makefile"
sed -ie 's/-o $(SAPI_CLI_PATH)/-all-static -o $(SAPI_CLI_PATH)/g' "Makefile"

cd ${__DIR__}

