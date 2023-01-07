## 变更
1.  新增设置CPU核数
1.  新增4个函数，功能分别是
    +  清理依赖库的构建目录
    +  依赖库在`./configure `之前的执行的脚本
    + 清除默认`ldflags`
    + 清除默认 `pkg-config`
1.  make `install`  添加定制项，当设置`withMakeInstallOptions` 需要添加 `install`参数



## 目的：提前准备构建环境

> 使用容器的多阶段构建，把依赖库打包到容器中，提前准备好构建环境。

多阶段构建
```dockerfile
COPY --from=1 /usr/libiconv /usr/libiconv
COPY --from=1 /usr/openssl/ /usr/openssl/
COPY --from=1  /usr/brotli/ /usr/brotli/
COPY --from=1 /usr/libxml2/ /usr/libxml2/
COPY --from=1 /usr/libxslt/ /usr/libxslt/

COPY --from=1  /usr/gmp/ /usr/gmp/

COPY --from=1  /usr/zlib /usr/zlib
COPY --from=1  /usr/bzip2 /usr/bzip2
COPY --from=1  /usr/liblzma /usr/liblzma
COPY --from=1  /usr/libzstd /usr/libzstd

COPY --from=1  /usr/zip /usr/zip

COPY --from=1  /usr/giflib /usr/giflib
COPY --from=1  /usr/libpng /usr/libpng
COPY --from=1  /usr/libjpeg /usr/libjpeg
COPY --from=1  /usr/freetype /usr/freetype
COPY --from=1  /usr/libwebp /usr/libwebp

COPY --from=1  /usr/sqlite3/ /usr/sqlite3/
COPY --from=1  /usr/oniguruma/ /usr/oniguruma/

COPY --from=1  /usr/curl/ /usr/curl/

COPY --from=1  /usr/libsodium/ /usr/libsodium/
COPY --from=1  /usr/libyaml /usr/libyaml
COPY --from=1  /usr/mimalloc/ /usr/mimalloc/

COPY --from=1  /usr/imagemagick /usr/imagemagick

```

比如zip 静态库，使用 `/usr/zip `目录
![image](https://user-images.githubusercontent.com/6836228/210267847-37aa3267-adf4-453f-a44c-b4fbb8579c1a.png)

## 测试验证中发现
1.  `bzip2` 没有  `libbz2.pc` 文件，不能使用 `pkg-config` 命令，使用时需要手动指定
1. `libiconv`  不能使用 `pkg-config` 命令
1. 扩展 `mbstring ` 依赖库`oniguruma`
1. 扩展 `intl ` 依赖库 `ICU`
1. 扩展 `gd` 依赖库 `freetype` , `freetype`  依赖   `zlib bzip2 libpng  brotli `
1.  扩展'mongodb', 依赖库 `openssl`, `zlib`等


## 测试验证中，依赖库使用的pkg-name
```shell

BZIP2_CFLAGS='-I/usr/bzip2/include'
BZIP2_LIBS='-L/usr/bzip2/lib -lbz2'

export  ZLIB_CFLAGS=$(pkg-config --cflags zlib) ;
export  ZLIB_LIBS=$(pkg-config --libs zlib) ;

export LIBPNG_LIBS=$(pkg-config --cflags libpng libpng16) ;
export LIBPNG_LIBS=$(pkg-config --libs libpng libpng16) ;


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

export   ONIG_CFLAGS=$(pkg-config --cflags oniguruma) ;
export   ONIG_LIBS=$(pkg-config --libs oniguruma) ;


export   LIBSODIUM_CFLAGS=$(pkg-config --cflags libsodium) ;
export   LIBSODIUM_LIBS=$(pkg-config --libs libsodium) ;

export   XSL_CFLAGS=$(pkg-config --cflags libxslt) ;
export   XSL_LIBS=$(pkg-config --libs libxslt) ;

EXSLT_CFLAGS=$(pkg-config --cflags libexslt) ;
EXSLT_LIBS=$(pkg-config --libs libexslt) ;


export    LIBZIP_CFLAGS=$(pkg-config --cflags libzip) ;
export   LIBZIP_LIBS=$(pkg-config --libs libzip) ;


#  SWOOLE_CFLAGS="$SWOOLE_CFLAGS $LIBPQ_CFLAGS"
#  SWOOLE_PGSQL_CFLAGS="$SWOOLE_CFLAGS $LIBPQ_CFLAGS"

```

