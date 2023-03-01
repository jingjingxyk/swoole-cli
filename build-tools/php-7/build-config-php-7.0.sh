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


cpu_nums=`nproc`
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
mkdir -p ext/imagick
mkdir -p ext/ds
mkdir -p ext/inotify

test -d ext/swoole && rm -rf ext/swoole
cp -rf ${__DIR__}/download/swoole-src ext/swoole

tar --strip-components=1 -C ext/redis -xf ${__DIR__}/download/redis-5.3.7.tgz
tar --strip-components=1 -C ext/mongodb -xf ${__DIR__}/download/mongodb-1.15.0.tgz
tar --strip-components=1 -C ext/yaml -xf ${__DIR__}/download/yaml-2.2.2.tgz
tar --strip-components=1 -C ext/apcu -xf ${__DIR__}/download/apcu-5.1.22.tgz
tar --strip-components=1 -C ext/imagick -xf ${__DIR__}/download/imagick-3.6.0.tgz
tar --strip-components=1 -C ext/ds -xf ${__DIR__}/download/ds-1.4.0.tgz
tar --strip-components=1 -C ext/inotify -xf ${__DIR__}/download/inotify-3.0.0.tgz


# cp -f ext/openssl/config0.m4 ext/openssl/config.m4


OPTIONS="--disable-all \
--enable-shared=no \
--enable-static=yes \
--disable-cgi \
--disable-phpdbg \
--enable-json \
--enable-opcache \
--with-curl \
--with-iconv=/usr/libiconv \
--with-bz2=/usr/bzip2 \
--enable-bcmath \
--enable-pcntl \
--enable-filter \
--enable-session \
--enable-tokenizer \
--enable-mbstring \
--enable-ctype \
--with-zlib --with-zlib-dir=/usr/zlib \
--with-zip \
--enable-posix \
--enable-sockets \
--enable-pdo \
--with-sqlite3 \
--enable-phar \
--enable-mysqlnd \
--with-mysqli \
--enable-intl \
--enable-fileinfo \
--with-pdo_mysql  \
--with-pdo-sqlite \
--enable-soap \
--with-xsl \
--with-gmp=/usr/gmp \
--enable-exif \
--with-openssl --with-openssl-dir=/usr/openssl \
--with-readline=/usr/readline \
--enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom  \
--enable-redis \
--enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares --with-brotli-dir=/usr/brotli \
--with-yaml=/usr/libyaml \
--with-imagick=/usr/imagemagick \
--with-pgsql=/usr/pgsql \
--with-pdo-pgsql=/usr/pgsql \
--enable-apcu \
 --enable-ds \
--enable-inotify \
--with-curl=/usr/curl \
--enable-zip \
--with-libzip=/usr/libzip \
--enable-libxml \
--with-libxml-dir=/usr/libxml2 \
--with-jpeg-dir=/usr/libjpeg \
--with-freetype-dir=/usr/freetype \
--with-webp-dir=/usr/libwebp

"
# 扩展 GD 需要重新构建
# 扩展 mongdob 需要降版本
# 7.0 版本
#  不支持 sodium ffi
# unrecognized options：--with-zip, --with-sodium, --with-libxml, --enable-gd, --with-jpeg, --with-freetype, --with-webp, --with-ffi
:<<'EOF'
--with-curl=/usr/curl \
--enable-zip \
--with-libzip=/usr/libzip \
--enable-libxml \
--with-libxml-dir=/usr/libxml2 \
--with-jpeg-dir=/usr/libjpeg \
--with-freetype-dir=/usr/freetype \
--with-webp-dir=/usr/libwebp \
--with-gd=/usr/
EOF

test -f ./configure && rm ./configure ;

./buildconf --force ;

# 查看需要的配置信息
./configure --help | grep curl
./configure --help | grep zip
./configure --help | grep libxml
./configure --help | grep gd
./configure --help | grep jpeg
./configure --help | grep freetype
./configure --help | grep webp

export PATH=/usr/icu/bin:/usr/libxslt/bin:$PATH
xslt-config --cflags
xslt-config --libs

export   ICU_CFLAGS=$(pkg-config --cflags --static icu-i18n  icu-io   icu-uc)
export   ICU_LIBS=$(pkg-config   --libs   --static icu-i18n  icu-io   icu-uc)
export   ONIG_CFLAGS=$(pkg-config --cflags --static oniguruma)
export   ONIG_LIBS=$(pkg-config   --libs   --static oniguruma)
export   LIBSODIUM_CFLAGS=$(pkg-config --cflags --static libsodium)
export   LIBSODIUM_LIBS=$(pkg-config   --libs   --static libsodium)
export   LIBZIP_CFLAGS=$(pkg-config --cflags --static libzip) ;
export   LIBZIP_LIBS=$(pkg-config   --libs   --static libzip) ;
export   LIBPQ_CFLAGS=$(pkg-config  --cflags --static       libpq)
export   LIBPQ_LIBS=$(pkg-config    --libs   --static       libpq)


export   XSL_CFLAGS=$(pkg-config --cflags --static libxslt) ;
export   XSL_CFLAGS=$(xslt-config --cflags) ;
export   XSL_LIBS=$(pkg-config   --libs   --static libxslt) ;
export   XSL_LIBS=$(xslt-config --libs) ;


package_names="readline icu-i18n  icu-io   icu-uc libpq "
package_names="${package_names} openssl libcares  libidn2  libzstd libbrotlicommon  libbrotlidec  libbrotlienc"
package_names="${package_names} libcurl libjpeg libpng libturbojpeg libxslt"

CPPFLAGS=$(pkg-config  --cflags-only-I --static $package_names )
export   CPPFLAGS="$CPPFLAGS -I/usr/include"
LDFLAGS=$(pkg-config   --libs-only-L   --static $package_names )
export   LDFLAGS="$LDFLAGS -L/usr/lib"
LIBS=$(pkg-config      --libs-only-l   --static $package_names )
export  LIBS="$LIBS -lstdc++"


./configure --prefix=$install_prefix_dir $OPTIONS

sed -ie 's/-export-dynamic//g' "Makefile"
sed -ie 's/-o $(SAPI_CLI_PATH)/-all-static -o $(SAPI_CLI_PATH)/g' "Makefile"

cd ${__DIR__}

