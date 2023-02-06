#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)

cd ${__DIR__}

version=$(cat version.txt)
# php 7.4 不支持 openssl 3 版本，请使用openssl 1 版本

test -d ${__DIR__}/php-src && rm -rf ${__DIR__}/php-src
mkdir -p ${__DIR__}/php-src/

tar --strip-components=1 -C ${__DIR__}/php-src/ -xf ${__DIR__}/php-7.4.33.tar.gz
cd ${__DIR__}/php-src/


PKG_CONFIG_PATH=''
test -d /usr/lib/pkgconfig && PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/lib64/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH"


export PATH=/usr/c-ares/bin/:/usr/pgsql/bin/:/usr/libffi/bin/:/usr/icu_2/bin/:$PATH

export PKG_CONFIG_PATH=/usr/libiconv/lib/pkgconfig:/usr/openssl_1/lib/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/liblz4/lib/pkgconfig:/usr/liblzma/lib/pkgconfig:/usr/libzstd/lib/pkgconfig:/usr/zip/lib/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/libjpeg/lib64/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/imagemagick/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:/usr/icu_2/lib/pkgconfig:/usr/pgsql/lib/pkgconfig:/usr/c-ares/lib/pkgconfig:/usr/libffi/lib/pkgconfig:$PKG_CONFIG_PATH


install_prefix_dir="/tmp/${version}"
mkdir -p $install_prefix_dir

mkdir -p ext/redis
mkdir -p ext/mongodb
mkdir -p ext/yaml
mkdir -p ext/apcu

test -d ext/swoole && rm -rf ext/swoole
cp -rf ${__DIR__}/swoole-src ext/swoole

tar --strip-components=1 -C ext/redis -xf ${__DIR__}/redis-5.3.7.tgz
tar --strip-components=1 -C ext/mongodb -xf ${__DIR__}/mongodb-1.15.0.tgz
tar --strip-components=1 -C ext/yaml -xf ${__DIR__}/yaml-2.2.2.tgz
tar --strip-components=1 -C ext/apcu -xf ${__DIR__}/apcu-5.1.22.tgz

# cp -f ${__DIR__}/php-src/ext/openssl_1/config0.m4 ${__DIR__}/php-src/ext/openssl_1/config.m4

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


export  ICU_CFLAGS=$(pkg-config --cflags --static icu-uc icu-io icu-i18n)  ;
export  ICU_LIBS=$(pkg-config  --libs --static icu-uc icu-io icu-i18n)  ;



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




export  ONIG_CFLAGS=$(pkg-config --cflags oniguruma) ;
export  ONIG_LIBS=$(pkg-config --libs oniguruma) ;

export   LIBSODIUM_CFLAGS=$(pkg-config --cflags libsodium) ;
export   LIBSODIUM_LIBS=$(pkg-config --libs libsodium) ;

export   XSL_CFLAGS=$(pkg-config --cflags libxslt) ;
export   XSL_LIBS=$(pkg-config --libs libxslt) ;

export   EXSLT_CFLAGS=$(pkg-config --cflags libexslt) ;
export   EXSLT_LIBS=$(pkg-config --libs libexslt) ;


export   LIBZIP_CFLAGS=$(pkg-config --cflags libzip) ;
export   LIBZIP_LIBS=$(pkg-config --libs libzip) ;

export LIBPQ_CFLAGS=$(pkg-config  --cflags --static      libpq)

export LIBPQ_LIBS=$(pkg-config  --libs  --static       libpq)

pkg-config  --cflags --static  libffi
pkg-config  --libs --static   libffi

CPPFLAGS=$(pkg-config  --cflags --static  libpq ncurses readline libcares libffi)
LIBS=$(pkg-config  --libs --static   libpq ncurses readline libcares libffi)


export CPPFLAGS="$CPPFLAGS -I/usr/include"
export LIBS="$LIBS -L/usr/lib -lstdc++"

which icu-config
export CXXFLAGS=$(icu-config --cxxflags)
export LDFLAGS=$(icu-config --ldflags)


:<<'EOF'
# export   NCURSES_CFLAGS=$(pkg-config --cflags formw  menuw  ncursesw panelw);
# export   NCURSES_LIBS=$(pkg-config  --libs formw  menuw  ncursesw panelw);

# export   READLINE_CFLAGS=$(pkg-config --cflags  readline)  ;
# export   READLINE_LIBS=$(pkg-config  --libs readline)  ;
EOF



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
    --enable-dom \
    --enable-fileinfo \
    --enable-filter \
    --enable-json \
    --enable-dom \
    --enable-pdo \
    --enable-phar \
    --enable-posix \
    --enable-session \
    --enable-tokenizer \
    --with-iconv=/usr/libiconv \
    --enable-mysqlnd \
    --with-pdo-sqlite \
    --with-pdo-mysql=mysqlnd \
    --with-sqlite3=/usr/sqlite3 \
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
    --with-openssl --with-openssl-dir=/usr/openssl_1 \
    --enable-gd \
    --with-yaml=/usr/libyaml \
    --enable-swoole  --enable-swoole-curl  --enable-http2 --enable-swoole-json \
    --enable-redis \
    --enable-apcu \
    --with-ffi=/usr/libffi \
    --enable-opcache \
    --enable-intl \
    --enable-mongodb \
    --with-pgsql=/usr/pgsql \
    --with-pdo-pgsql=/usr/pgsql

#    --enable-mongodb \ # need icu
#   --enable-intl \ # use icu
#    --with-pgsql=/usr/pgsql \
#    --with-pdo-pgsql=/usr/pgsql \

sed -ie 's/-export-dynamic//g' "Makefile"
sed -ie 's/-o $(SAPI_CLI_PATH)/-all-static -o $(SAPI_CLI_PATH)/g' "Makefile"

cd ${__DIR__}

