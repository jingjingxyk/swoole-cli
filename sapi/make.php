<?php
/**
 * @var $this SwooleCli\Preprocessor
 */
?>
set -uex
PKG_CONFIG_PATH='/usr/lib/pkgconfig'
test -d /usr/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/lib64/pkgconfig:$PKG_CONFIG_PATH" ;
test -d /usr/local/lib/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" ;
test -d /usr/local/lib64/pkgconfig && PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH" ;

SRC=<?= $this->phpSrcDir . PHP_EOL ?>
ROOT=$(pwd)
export CC=clang
export CXX=clang++
export LD=ld.lld
export PKG_CONFIG_PATH=<?= implode(':', $this->pkgConfigPaths) . PHP_EOL ?>
export ORIGIN_PKG_CONFIG_PATH=$PKG_CONFIG_PATH
OPTIONS="--disable-all \
<?php foreach ($this->extensionList as $item) : ?>
    <?= $item->options ?> \
<?php endforeach; ?>
<?= $this->extraOptions ?>
"

<?php foreach ($this->libraryList as $item) : ?>
    make_<?=$item->name?>() {
    cd <?=$this->workDir?>/thirdparty
    echo "build <?=$item->name?>"
    <?php if ($item->cleanBuildDirectory) : ?>
        test -d <?= $this->workDir ?>/thirdparty/<?= $item->name ?> && rm -rf <?= $this->workDir ?>/thirdparty/<?= $item->name ?> ;
    <?php endif; ?>
    mkdir -p <?=$this->workDir?>/thirdparty/<?=$item->name?> && \
    tar --strip-components=1 -C <?=$this->workDir?>/thirdparty/<?=$item->name?> -xf <?=$this->workDir?>/pool/lib/<?=$item->file?>  && \
    cd <?=$item->name?> ;
    <?php if (!empty($item->beforeConfigureScript)) : ?>
        <?= $item->beforeConfigureScript . PHP_EOL ?>
    <?php endif; ?>
    :;
    echo <<'EOF'
    <?= $item->configure . PHP_EOL ?>
EOF
    <?php if (!empty($item->configure)): ?>
        <?=$item->configure?> && \
    <?php endif; ?>
    make -j <?=$this->maxJob?>  <?=$item->makeOptions?> && \
    <?php if (!empty($item->beforeInstallScript)): ?>
        <?=$item->beforeInstallScript?> && \
    <?php endif; ?>
    make <?=$item->makeInstallDefaultOptions?> <?=$item->makeInstallOptions?> && \
    <?php if ($item->afterInstallScript): ?>
        <?=$item->afterInstallScript?>
    <?php endif; ?>
    cd -
    }

    clean_<?= $item->name ?>() {
        cd <?= $this->workDir ?>/thirdparty
        echo "clean <?= $item->name ?>"
        cd <?= $this->workDir ?>/thirdparty/<?= $item->name ?> && make clean
        cd -
    }
    <?php echo str_repeat(PHP_EOL, 1); ?>

<?php endforeach; ?>

make_all_library() {
<?php foreach ($this->libraryList as $item) : ?>
    make_<?= $item->name ?> && echo "[SUCCESS] make <?= $item->name ?>"
<?php endforeach; ?>
}

config_php() {

    git config --global --add safe.directory "*"


<?php if (0 == true) : ?>
    test -f main/main.c.save ||  cp -f main/main.c main/main.c.save ;
    sed -i 's/extern zend_extension zend_extension_entry;//g' main/main.c ;
    sed -i 's/zend_register_extension(&zend_extension_entry, NULL);//g' main/main.c ;
<?php else : ?>
    test -f main/main.c.save &&  cp -f main/main.c.save main/main.c ;
<?php endif; ?>
    test -f ./configure && rm ./configure ;


    LIBXML_CFLAGS=$(pkg-config --cflags libxml-2.0) ;
    LIBXML_LIBS=$(pkg-config --libs libxml-2.0) ;


    OPENSSL_CFLAGS=$(pkg-config --cflags openssl libcrypto libssl) ;
    OPENSSL_LIBS=$(pkg-config --libs openssl libcrypto libssl) ;

:<<'EOF'
    PCRE2_CFLAGS=$(pkg-config --cflags libpcre2-8 libpcre2-posix) ;
    PCRE2_LIBS=$(pkg-config --libs libpcre2-8 libpcre2-posix) ;
EOF

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

:<<'EOF'
    GDLIB_CFLAGS=$(pkg-config --cflags "no install") ;
    GDLIB_LIBS=$(pkg-config --libs "no install") ;
EOF

    ICU_CFLAGS=$(pkg-config --cflags  icu-uc icu-io icu-i18n)  ;
    ICU_LIBS=$(pkg-config  --libs icu-uc icu-io icu-i18n)  ;

export   ONIG_CFLAGS=$(pkg-config --cflags oniguruma) ;
export   ONIG_LIBS=$(pkg-config --libs oniguruma) ;

:<<'EOF'
    PHP_MONGODB_SNAPPY_CFLAGS=$(pkg-config --cflags "no install") ;
    PHP_MONGODB_SNAPPY_LIBS=$(pkg-config --libs "no install") ;
EOF
:<<'EOF'
    PHP_MONGODB_ZLIB_CFLAGS=$(pkg-config --cflags zlib) ;
    PHP_MONGODB_ZLIB_LIBS=$(pkg-config --libs zlib) ;
    PHP_MONGODB_ZSTD_CFLAGS=$(pkg-config --cflags libzstd) ;
    PHP_MONGODB_ZSTD_LIBS=$(pkg-config --libs libzstd) ;
EOF
:<<'EOF'
    PHP_MONGODB_SASL_CFLAGS=$(pkg-config --cflags sasl) ;
EOF
:<<'EOF'
    PHP_MONGODB_SSL_CFLAGS=$(pkg-config --cflags openssl libcrypto libssl) ;
    PHP_MONGODB_SSL_LIBS=$(pkg-config --libs openssl libcrypto libssl) ;
    PHP_MONGODB_ICU_CFLAGS=$(pkg-config --cflags icu-uc icu-io icu-i18n) ;
    PHP_MONGODB_ICU_LIBS=$(pkg-config --libs icu-uc icu-io icu-i18n) ;
EOF
:<<'EOF'
    EDIT_CFLAGS=$(pkg-config --cflags "no install") ;
    EDIT_LIBS=$(pkg-config --libs "no install") ;
EOF


export   LIBSODIUM_CFLAGS=$(pkg-config --cflags libsodium) ;
export   LIBSODIUM_LIBS=$(pkg-config --libs libsodium) ;

export       XSL_CFLAGS=$(pkg-config --cflags libxslt) ;
export       XSL_LIBS=$(pkg-config --libs libxslt) ;

    EXSLT_CFLAGS=$(pkg-config --cflags libexslt) ;
    EXSLT_LIBS=$(pkg-config --libs libexslt) ;


export    LIBZIP_CFLAGS=$(pkg-config --cflags libzip) ;
export   LIBZIP_LIBS=$(pkg-config --libs libzip) ;

    NCURSES_CFLAGS=$(pkg-config --cflags formw  menuw  ncursesw panelw);
    NCURSES_LIBS=$(pkg-config  --libs formw  menuw  ncursesw panelw);

    READLINE_CFLAGS=$(pkg-config --cflags  readline)  ;
    READLINE_LIBS=$(pkg-config  --libs readline)  ;


:<<'EOF'

    SWOOLE_CFLAGS=$(pkg-config  --cflags libcares)
    LIBPQ_CFLAGS=$(pkg-config  --cflags "no install")
    LIBPQ_LIBS=$(pkg-config  --libs "no install")

EOF

:<<'EOF'
    swoole 配置
    $SWOOLE_CFLAGS $LIBPQ_CFLAGS

    LIBPQ_CFLAGS and LIBPQ_LIBS

    SWOOLE_PGSQL_CFLAGS

    dnl FIXME: this should be SWOOLE_CFLAGS="$SWOOLE_CFLAGS $LIBPQ_CFLAGS"
    dnl or SWOOLE_PGSQL_CFLAGS="$SWOOLE_CFLAGS $LIBPQ_CFLAGS" and SWOOLE_PGSQL_CFLAGS only applies to ext-src/swoole_postgresql_coro.cc
    EXTRA_CFLAGS="$EXTRA_CFLAGS $LIBPQ_CFLAGS"
    PHP_EVAL_LIBLINE($LIBPQ_LIBS, SWOOLE_SHARED_LIBADD)

EOF


    ./buildconf --force ;
    ./configure --help


<?php if ($this->osType !== 'macos') : ?>
    mv main/php_config.h.in /tmp/cnt
    echo -ne '#ifndef __PHP_CONFIG_H\n#define __PHP_CONFIG_H\n' > main/php_config.h.in
    cat /tmp/cnt >> main/php_config.h.in
    echo -ne '\n#endif\n' >> main/php_config.h.in
<?php endif; ?>
    echo $OPTIONS ;
    echo $PKG_CONFIG_PATH ;
    ./configure $OPTIONS ;
}

make_php() {
    make EXTRA_CFLAGS='-fno-ident -Xcompiler -march=nehalem -Xcompiler -mtune=haswell -Os' \
    EXTRA_LDFLAGS_PROGRAM='-all-static -fno-ident <?= $this->extraLdflags ?><?php
foreach ($this->libraryList as $item) {
    if (!empty($item->ldflags)) {
        echo $item->ldflags;
        echo ' ';
    }
} ?>'  -j <?= $this->maxJob ?> && echo ""
}

help() {
    echo "./make.sh docker-bash"
    echo "./make.sh config"
    echo "./make.sh build"
    echo "./make.sh archive"
    echo "./make.sh all-library"
    echo "./make.sh clean-all-library"
    echo "./make.sh sync"
}

if [ "$1" = "docker-build" ] ;then
    sudo docker build -t phpswoole/swoole_cli_os:<?= $this->dockerVersion ?> .
elif [ "$1" = "docker-bash" ] ;then
    sudo docker run -it -v $ROOT:<?= $this->workDir ?> --workdir <?= $this->workDir ?> phpswoole/swoole_cli_os:<?= $this->dockerVersion ?> /bin/bash
    exit 0
elif [ "$1" = "all-library" ] ;then
    make_all_library
<?php foreach ($this->libraryList as $item) : ?>
elif [ "$1" = "<?= $item->name ?>" ] ;then
    make_<?= $item->name ?> && echo "[SUCCESS] make <?= $item->name ?>"
elif [ "$1" = "clean-<?= $item->name ?>" ] ;then
    clean_<?= $item->name ?> && echo "[SUCCESS] make clean <?= $item->name ?>"
<?php endforeach; ?>
elif [ "$1" = "config" ] ;then
    config_php
elif [ "$1" = "build" ] ;then
    make_php
elif [ "$1" = "archive" ] ;then
    cd bin
    SWOOLE_VERSION=$(./swoole-cli -r "echo SWOOLE_VERSION;")
    SWOOLE_CLI_FILE=swoole-cli-v${SWOOLE_VERSION}-<?= $this->getOsType() ?>-x64.tar.xz
    strip swoole-cli
    tar -cJvf ${SWOOLE_CLI_FILE} swoole-cli LICENSE
    mv ${SWOOLE_CLI_FILE} ../
    cd -
elif [ "$1" = "clean-all-library" ] ;then
<?php foreach ($this->libraryList as $item) : ?>
    clean_<?= $item->name ?> && echo "[SUCCESS] make clean [<?= $item->name ?>]"
<?php endforeach; ?>
elif [ "$1" = "diff-configure" ] ;then
    meld $SRC/configure.ac ./configure.ac
elif [ "$1" = "pkg-check" ] ;then
set +x
<?php foreach ($this->libraryList as $item) : ?>
    <?php if (!empty($item->pkgName)) : ?>
    echo "[<?= $item->name ?>]"
    # pkg-config --libs <?= ($item->pkgName ?: $item->name) . PHP_EOL; ?>
    pkg-config --cflags <?= $item->pkgName . PHP_EOL ?>
    pkg-config --libs <?= $item->pkgName . PHP_EOL ?>
    echo "==========================================================="
    <?php endif; ?>
<?php endforeach; ?>
set -x
elif [ "$1" = "sync" ] ;then
    echo "sync"
    # ZendVM
    cp -r $SRC/Zend ./
    # Extension
    cp -r $SRC/ext/bcmath/ ./ext
    cp -r $SRC/ext/bz2/ ./ext
    cp -r $SRC/ext/calendar/ ./ext
    cp -r $SRC/ext/ctype/ ./ext
    cp -r $SRC/ext/curl/ ./ext
    cp -r $SRC/ext/date/ ./ext
    cp -r $SRC/ext/dom/ ./ext
    cp -r $SRC/ext/exif/ ./ext
    cp -r $SRC/ext/fileinfo/ ./ext
    cp -r $SRC/ext/filter/ ./ext
    cp -r $SRC/ext/gd/ ./ext
    cp -r $SRC/ext/gettext/ ./ext
    cp -r $SRC/ext/gmp/ ./ext
    cp -r $SRC/ext/hash/ ./ext
    cp -r $SRC/ext/iconv/ ./ext
    cp -r $SRC/ext/intl/ ./ext
    cp -r $SRC/ext/json/ ./ext
    cp -r $SRC/ext/libxml/ ./ext
    cp -r $SRC/ext/mbstring/ ./ext
    cp -r $SRC/ext/mysqli/ ./ext
    cp -r $SRC/ext/mysqlnd/ ./ext
    cp -r $SRC/ext/opcache/ ./ext
    sed -i 's/ext_shared=yes/ext_shared=no/g' ext/opcache/config.m4 && sed -i 's/shared,,/$ext_shared,,/g' ext/opcache/config.m4
    echo -e '#include "php.h"\n\nextern zend_module_entry opcache_module_entry;\n#define phpext_opcache_ptr  &opcache_module_entry\n' > ext/opcache/php_opcache.h
    cp -r $SRC/ext/openssl/ ./ext
    cp -r $SRC/ext/pcntl/ ./ext
    cp -r $SRC/ext/pcre/ ./ext
    cp -r $SRC/ext/pdo/ ./ext
    cp -r $SRC/ext/pdo_mysql/ ./ext
    cp -r $SRC/ext/pdo_pgsql/ ./ext
    cp -r $SRC/ext/pdo_sqlite/ ./ext
    cp -r $SRC/ext/phar/ ./ext
    cp -r $SRC/ext/posix/ ./ext
    cp -r $SRC/ext/readline/ ./ext
    cp -r $SRC/ext/reflection/ ./ext
    cp -r $SRC/ext/session/ ./ext
    cp -r $SRC/ext/simplexml/ ./ext
    cp -r $SRC/ext/soap/ ./ext
    cp -r $SRC/ext/sockets/ ./ext
    cp -r $SRC/ext/sodium/ ./ext
    cp -r $SRC/ext/spl/ ./ext
    cp -r $SRC/ext/skeleton/ ./ext
    cp -r $SRC/ext/sqlite3/ ./ext
    cp -r $SRC/ext/standard/ ./ext
    cp -r $SRC/ext/sysvshm/ ./ext
    cp -r $SRC/ext/tokenizer/ ./ext
    cp -r $SRC/ext/xml/ ./ext
    cp -r $SRC/ext/xmlreader/ ./ext
    cp -r $SRC/ext/xmlwriter/ ./ext
    cp -r $SRC/ext/xsl/ ./ext
    cp -r $SRC/ext/zip/ ./ext
    cp -r $SRC/ext/zlib/ ./ext
    # main
    cp -r $SRC/main ./
    sed -i 's/\/\* start Zend extensions \*\//\/\* start Zend extensions \*\/\n\textern zend_extension zend_extension_entry;\n\tzend_register_extension(\&zend_extension_entry, NULL);/g' main/main.c
    # build
    cp -r $SRC/build ./
    # TSRM
    cp -r ./TSRM/TSRM.h main/TSRM.h
    cp -r $SRC/configure.ac ./
    # fpm
    cp -r $SRC/sapi/fpm/fpm ./sapi/cli
    exit 0
else
    help
fi


