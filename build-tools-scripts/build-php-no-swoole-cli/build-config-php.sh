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

version=PHP-7.4.33

cd ${__DIR__}/php-src/


PKG_CONFIG_PATH=''
test -d /usr/lib/pkgconfig && PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/lib64/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
test -d /usr/local/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH"


export PKG_CONFIG_PATH=/usr/libiconv/lib/pkgconfig:/usr/openssl/lib/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/liblz4/lib/pkgconfig:/usr/liblzma/lib/pkgconfig:/usr/libzstd/lib/pkgconfig:/usr/zip/lib/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/libjpeg/lib64/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/imagemagick/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:$PKG_CONFIG_PATH


install_prefix_dir="/tmp/${version}/php/"
mkdir -p $install_prefix_dir

mkdir -p ext/redis
mkdir -p ext/mongodb

tar --strip-components=1 -C ext/redis -xf /work/pool/ext/redis-5.3.7.tgz
tar --strip-components=1 -C ext/mongodb -xf /work/pool/ext/mongodb-1.14.2.tgz


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


export  ICU_CFLAGS=$(pkg-config --cflags  icu-uc icu-io icu-i18n)  ;
export  ICU_LIBS=$(pkg-config  --libs icu-uc icu-io icu-i18n)  ;

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

:<<'EOF'
# export   NCURSES_CFLAGS=$(pkg-config --cflags formw  menuw  ncursesw panelw);
# export   NCURSES_LIBS=$(pkg-config  --libs formw  menuw  ncursesw panelw);

# export   READLINE_CFLAGS=$(pkg-config --cflags  readline)  ;
# export   READLINE_LIBS=$(pkg-config  --libs readline)  ;
EOF



test -f ./configure && rm ./configure ;
./buildconf --force ;



LDFLAGS=-static
./configure --prefix=$install_prefix_dir \
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
    --with-pdo-sqlite \
    --with-sqlite3=/usr/sqlite3 \
    --enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml=/usr/libxml2 \
    --with-curl=/usr/curl \
    --with-bz2=/usr/bzip2 \
    --with-zlib=/usr/zlib/ \
    --enable-bcmath \
    --enable-pcntl \
    --enable-mbstring \
    --enable-sockets \
    --enable-mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-xsl=/usr/libxslt \
    --with-gmp=/usr/gmp \
    --with-sodium=/usr/libsodium \
    --enable-intl \
    --with-readline \
    --with-openssl --with-openssl-dir=/usr/openssl \
    --enable-redis \
    --enable-mongodb \
    --enable-gd \
    --enable-bz2

# --enable-intl  # use icu

sed -ie 's/-export-dynamic//g' "Makefile"
sed -ie 's/-o $(SAPI_CLI_PATH)/-all-static -o $(SAPI_CLI_PATH)/g' "Makefile"

cd ${__DIR__}

