#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)


cd ${__DIR__}


export PATH=/usr/pgsql/bin/:/usr/libffi/bin/:$PATH

PKG_CONFIG_PATH=''
test -d /usr/lib/pkgconfig && PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"

export CC=clang
export CXX=clang++
export LD=ld.lld
export PKG_CONFIG_PATH=/usr/openssl/lib/pkgconfig:/usr/libxml2/lib/pkgconfig:/usr/libxslt/lib/pkgconfig:/usr/brotli/lib/pkgconfig:/usr/cares/lib/pkgconfig:/usr/gmp/lib/pkgconfig:/usr/ncurses/lib/pkgconfig:/usr/readline/lib/pkgconfig:/usr/libyaml/lib/pkgconfig:/usr/libsodium/lib/pkgconfig:/usr/bzip2/lib/pkgconfig:/usr/zlib/lib/pkgconfig:/usr/liblz4/lib/pkgconfig:/usr/liblzma/lib/pkgconfig:/usr/libzstd/lib/pkgconfig:/usr/libzip/lib/pkgconfig:/usr/sqlite3/lib/pkgconfig:/usr/icu/lib/pkgconfig:/usr/oniguruma/lib/pkgconfig:/usr/mimalloc/lib/pkgconfig:/usr/libjpeg/lib64/pkgconfig:/usr/libpng/lib/pkgconfig:/usr/libwebp/lib/pkgconfig:/usr/freetype/lib/pkgconfig:/usr/imagemagick/lib/pkgconfig:/usr/libidn2/lib/pkgconfig:/usr/curl/lib/pkgconfig:/usr/pgsql/lib/pkgconfig:/usr/libffi/lib/pkgconfig:$PKG_CONFIG_PATH


version=$(cat version.txt)

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
mkdir -p ext/swoole


tar --strip-components=1 -C ext/redis -xf ${__DIR__}/download/redis-5.3.7.tgz
tar --strip-components=1 -C ext/mongodb -xf ${__DIR__}/download/mongodb-1.15.0.tgz
tar --strip-components=1 -C ext/yaml -xf ${__DIR__}/download/yaml-2.2.2.tgz
tar --strip-components=1 -C ext/apcu -xf ${__DIR__}/download/apcu-5.1.22.tgz
tar --strip-components=1 -C ext/imagick -xf ${__DIR__}/download/imagick-3.6.0.tgz
tar --strip-components=1 -C ext/ds -xf ${__DIR__}/download/ds-1.4.0.tgz
tar --strip-components=1 -C ext/inotify -xf ${__DIR__}/download/inotify-3.0.0.tgz

# tar --strip-components=1 -C ext/swoole -xf ${__DIR__}/swoole-5.0.1.tgz
tar --strip-components=1 -C ext/swoole -xf ${__DIR__}/download/swoole-v5.0.2.tar.gz

# cp -f ${__DIR__}/php-src/ext/openssl_1/config0.m4 ${__DIR__}/php-src/ext/openssl_1/config.m4

# 参考文档： https://github.com/dixyes/phpmicro/tree/master/patches
# 参考文档： https://github.com/easysoft/phpmicro/tree/master/patches

cp -rf ${__DIR__}/download/phpmicro/ sapi/micro

# 打patch

patch -p1 < sapi/micro/patches/phar.patch
# patch -p1 < sapi/micro/patches/cli_checks_81.patch
patch -p1 < sapi/micro/patches/static_opcache_81.patch
patch -p1 < sapi/micro/patches/disable_huge_page.patch



OPTIONS="--disable-all \
--enable-shared=no \
--enable-static=yes \
--disable-cgi \
--disable-phpdbg \
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
--with-sodium \
--with-openssl --with-openssl-dir=/usr/openssl \
--with-readline=/usr/readline \
--enable-xml --enable-simplexml --enable-xmlreader --enable-xmlwriter --enable-dom --with-libxml \
--enable-gd --with-jpeg --with-freetype --with-webp \
--enable-redis \
--enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares --with-brotli-dir=/usr/brotli \
--with-yaml=/usr/libyaml \
--with-imagick=/usr/imagemagick \
--with-pgsql=/usr/pgsql \
--with-pdo-pgsql=/usr/pgsql \
--enable-mongodb \
--enable-apcu \
--with-ffi \
 --enable-ds \
--enable-inotify \
--enable-micro=all-static

"

# --enable-mongodb \
# mongodb 扩展暂时（2023-02-26）不支持 php-8.20
# mongodb 扩展支持 php-8.1
# 扩展 --enable-micro=yes 或者   --enable-micro=all-static （区别请看文档：https://github.com/dixyes/phpmicro


test -f ./configure && rm ./configure ;

./buildconf --force ;

./configure --help

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
export   XSL_LIBS=$(pkg-config   --libs   --static libxslt) ;


package_names="readline icu-i18n  icu-io   icu-uc libpq libffi"
package_names="${package_names} openssl libcares  libidn2  libzstd libbrotlicommon  libbrotlidec  libbrotlienc"
package_names="${package_names} "

CPPFLAGS=$(pkg-config  --cflags-only-I --static $package_names )
export   CPPFLAGS="$CPPFLAGS -I/usr/include"
LDFLAGS=$(pkg-config   --libs-only-L   --static $package_names )
export   LDFLAGS="$LDFLAGS -L/usr/lib"
LIBS=$(pkg-config      --libs-only-l   --static $package_names )
export  LIBS="$LIBS -lstdc++"

./configure  --prefix=$install_prefix_dir $OPTIONS

sed -ie 's/-export-dynamic//g' "Makefile"
sed -ie 's/-o $(SAPI_CLI_PATH)/-all-static -o $(SAPI_CLI_PATH)/g' "Makefile"

cd ${__DIR__}

