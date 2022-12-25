#!/usr/bin/env php
<?php
require __DIR__ . '/sapi/Preprocessor.php';

use SwooleCli\Preprocessor;
use SwooleCli\Library;

error_reporting(E_ALL);
ini_set("display_errors", 1);

$p = new Preprocessor(__DIR__);
#$p->setPhpSrcDir(getenv('HOME') . '/.phpbrew/build/php-8.1.12');
$p->setPhpSrcDir(__DIR__ . '/build-tools-scripts/php-versions/php-8.1.12');
$p->setDockerVersion('1.4');
if (!empty($argv[1])) {
    $p->setOsType(trim($argv[1]));
}

if ($p->osType == 'macos') {
    $p->setWorkDir(__DIR__);
    $p->setExtraLdflags('-framework CoreFoundation -framework SystemConfiguration -undefined dynamic_lookup -lwebp -licudata -licui18n -licuio');
    //$p->setExtraOptions('--with-config-file-path=/usr/local/etc');
    $p->addEndCallback(function () use ($p) {
        file_put_contents(__DIR__ . '/make.sh', str_replace('/usr', $p->getWorkDir() . '/usr', file_get_contents(__DIR__ . '/make.sh')));
    });
}

# 设置CPU核数 ; 获取CPU核数，用于 make -j $(nproc)
$p->setMaxJob(`nproc 2> /dev/null || sysctl -n hw.ncpu`); // nproc on macos ；

// ================================================================================================
// Library
// ================================================================================================



function install_gettext(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('gettext', '/usr/gettext'))
            ->withUrl('https://ftp.gnu.org/pub/gnu/gettext/gettext-0.21.1.tar.gz')
            ->withPkgConfig('')
            ->withLdflags('-L/usr/gettext/lib')
            ->withConfigure('./configure --prefix=/usr/gettext enable_static=yes enable_shared=no --with-libiconv-prefix=/usr/libiconv/')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}

function install_libiconv(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libiconv', '/usr/libiconv'))
            ->withUrl('https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz')
            ->withPkgConfig('')
            ->withLdflags('-L/usr/libiconv/lib')
            ->withConfigure('./configure --prefix=/usr/libiconv enable_static=yes enable_shared=no')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}

function install_openssl(Preprocessor $p)
{
    $p->addLibrary((new Library('openssl', '/usr/openssl'))
        ->withUrl('https://www.openssl.org/source/openssl-3.0.7.tar.gz')
        ->withFile('openssl-3.0.7.tar.gz')
        ->withConfigure('./config' . ($p->osType === 'macos' ? '' : ' -static --static') . ' no-shared --release --prefix=/usr/openssl')
        ->withMakeInstallOptions('install_sw')
        ->withPkgConfig('/usr/openssl/lib64/pkgconfig')
        ->withLdflags('-L/usr/openssl/lib64')
        ->withLicense('https://github.com/openssl/openssl/blob/master/LICENSE.txt', Library::LICENSE_APACHE2)
        ->withHomePage('https://www.openssl.org/')
    );
}

// MUST be in the /usr directory
// Dependent libiconv
function install_libxml2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libxml2'))
            ->withUrl('https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.9.10/libxml2-v2.9.10.tar.gz')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libxml2 --with-iconv=/usr/libiconv --enable-static=yes --enable-shared=no')
            ->withPkgName('libxml-2.0')
            ->withPkgConfig('/usr/libxml2/lib/pkgconfig')
            ->withLdflags('-L/usr/libxml2/lib')
            ->withLicense('http://www.opensource.org/licenses/mit-license.html', Library::LICENSE_MIT)
    );
}

// MUST be in the /usr directory
// Dependent libxml2
function install_libxslt(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libxslt'))
            ->withUrl('https://gitlab.gnome.org/GNOME/libxslt/-/archive/v1.1.34/libxslt-v1.1.34.tar.gz')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libxslt   --enable-static=yes --enable-shared=no')
            ->withPkgConfig('/usr/libxslt/lib/pkgconfig')
            ->withLdflags('-L/usr/libxslt/lib')
            ->withLicense('http://www.opensource.org/licenses/mit-license.html', Library::LICENSE_MIT)
    );
}

function install_imagemagick(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('imagemagick', '/usr/imagemagick'))
            ->withUrl('https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.0-53.tar.gz')
            ->withConfigure('./configure --prefix=/usr/imagemagick --enable-static --disable-shared --with-zip=no --with-fontconfig=no --with-heic=no --with-lcms=no --with-lqr=no --with-openexr=no --with-openjp2=no --with-pango=no --with-raw=no --with-tiff=no')
            ->withPkgName('ImageMagick')
            ->withLicense('https://imagemagick.org/script/license.php', Library::LICENSE_APACHE2)
    );
}

function install_gmp(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('gmp', '/usr/gmp'))
            ->withUrl('https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz')
            ->withConfigure('./configure --prefix=/usr/gmp --enable-static --disable-shared')
            ->withPkgConfig('/usr/gmp/lib/pkgconfig')
            ->withLdflags('-L/usr/gmp/lib')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}

function install_giflib(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('giflib'))
            ->withUrl('https://nchc.dl.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz')
            //->withMakeOptions('libgif.a')
            ->withConfigureBeforeCleanPackage()
            ->withConfigureBeforeScript('sed -i "s@PREFIX = /usr/local@PREFIX = /usr/giflib@" Makefile')
            ->withMakeOptions('all')
            ->withMakeInstallOptions("install")
            ->withLdflags('-L/usr/giflib/lib')
            ->disableDefaultLdflags()
            //->withPkgConfig('/usr/giflib/lib/pkgconfig') //此目录不存在
            ->withLicense('http://giflib.sourceforge.net/intro.html', Library::LICENSE_SPEC)
    );
}

function install_libpng(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libpng', '/usr/libpng'))
            ->withUrl('https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz')
            ->withConfigure('./configure --prefix=/usr/libpng --enable-static --disable-shared')
            ->withLicense('http://www.libpng.org/pub/png/src/libpng-LICENSE.txt', Library::LICENSE_SPEC)
    );
}

function install_libjpeg(Preprocessor $p)
{
    $lib = new Library('libjpeg');
    $lib->withUrl('https://codeload.github.com/libjpeg-turbo/libjpeg-turbo/tar.gz/refs/tags/2.1.2')
        ->withConfigure('cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/libjpeg .')
        ->withLdflags('-L/usr/libjpeg/lib64')
        ->withPkgConfig('/usr/libjpeg/lib64/pkgconfig')
        ->withFile('libjpeg-turbo-2.1.2.tar.gz')
        ->withHomePage('https://libjpeg-turbo.org/')
        ->withLicense('https://github.com/libjpeg-turbo/libjpeg-turbo/blob/main/LICENSE.md', Library::LICENSE_BSD);
    if ($p->osType === 'macos') {
        $lib->withScriptAfterInstall('find ' . $lib->prefix . ' -name \*.dylib | xargs rm -f');
    }
    $p->addLibrary($lib);
}

function install_freetype(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('freetype', '/usr/freetype'))
            // DNS 无解析 dig mirror.yongbok.net
            //->withUrl('https://mirror.yongbok.net/nongnu/freetype/freetype-2.10.4.tar.gz')
            ->withUrl('https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.gz')
            ->withConfigure('./configure --prefix=/usr/freetype --enable-static --disable-shared')
            ->withLdflags('-L/usr/freetype/lib/')
            ->withPkgConfig('/usr/freetype/lib/pkgconfig')
            ->withHomePage('https://freetype.org/')
            ->withPkgName('freetype2')
            ->withLicense('https://gitlab.freedesktop.org/freetype/freetype/-/blob/master/docs/FTL.TXT', Library::LICENSE_SPEC)
    );
}

function install_libwebp(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libwebp', '/usr/libwebp'))
            ->withUrl('https://codeload.github.com/webmproject/libwebp/tar.gz/refs/tags/v1.2.1')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libwebp --enable-static --disable-shared')
            ->withFile('libwebp-1.2.1.tar.gz')
            ->withHomePage('https://github.com/webmproject/libwebp')
            ->withLicense('https://github.com/webmproject/libwebp/blob/main/COPYING', Library::LICENSE_SPEC)
    );
}

function install_sqlite3(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('sqlite3'))
            ->withUrl('https://www.sqlite.org/2021/sqlite-autoconf-3370000.tar.gz')
            ->withConfigure('./configure --prefix=/usr/sqlite3 --enable-static --disable-shared')
            ->withPkgConfig('/usr/sqlite3/lib/pkgconfig')
            ->withLdflags('-L/usr/sqlite3/lib')
            ->withHomePage('https://www.sqlite.org/index.html')
            ->withLicense('https://www.sqlite.org/copyright.html', Library::LICENSE_SPEC)
    );
}

function install_zlib(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('zlib'))
            ->withUrl('https://zlib.net/zlib-1.2.13.tar.gz')
            //->withUrl('https://udomain.dl.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz')
            ->withConfigure('./configure --prefix=/usr/zlib --static')
            ->withPkgConfig('/usr/zlib/lib/pkgconfig')
            ->withLdflags('-L/usr/zlib/lib')
            ->withHomePage('https://zlib.net/')
            ->withLicense('https://zlib.net/zlib_license.html', Library::LICENSE_SPEC)
    );
}



function install_bzip2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('bzip2', '/usr/bzip2'))
            ->withUrl('https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz')
            ->withMakeOptions('PREFIX=/usr/bzip2')
            ->withMakeInstallOptions('install PREFIX=/usr/bzip2')
            ->withLdflags('-L/usr/bzip2/lib')
            ->withHomePage('https://www.sourceware.org/bzip2/')
            ->withLicense('https://www.sourceware.org/bzip2/', Library::LICENSE_BSD)
    );
}


function install_lzma(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('lzma'))
            ->withUrl('https://tukaani.org/xz/xz-5.2.9.tar.gz')
            ->withFile('xz-5.2.9.tar.gz')
            ->withConfigure('./configure --prefix=/usr/liblzma/ --enable-static --disable-shared --disable-doc')
            ->withPkgName('liblzma')
            ->withPkgConfig('/usr/liblzma/lib/pkgconfig')
            ->withLdflags('-L/usr/liblzma/lib')
            ->withHomePage('https://tukaani.org/xz/')
            ->withLicense('https://git.tukaani.org/?p=xz.git;a=blob;f=COPYING', Library::LICENSE_LGPL)
    );
}
function install_zstd(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('zstd'))
            ->withUrl('https://github.com/facebook/zstd/releases/download/v1.5.2/zstd-1.5.2.tar.gz')
            ->withFile('zstd-1.5.2.tar.gz')
            ->withMakeOptions('lib')
            ->withMakeInstallOptions('install PREFIX=/usr/zstd/')
            ->withPkgName('libzstd.pc')
            ->withPkgConfig('/usr/zstd/lib/pkgconfig')
            ->withLdflags('-L/usr/zstd/lib')
            ->withHomePage('https://github.com/facebook/zstd')
            ->withLicense('https://github.com/facebook/zstd/blob/dev/COPYING', Library::LICENSE_GPL)
    );
}

// MUST be in the /usr directory
function install_zip(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('zip'))
            ->withUrl('https://libzip.org/download/libzip-1.9.2.tar.gz')
            //->withUrl('https://libzip.org/download/libzip-1.8.0.tar.gz')
            ->withFile('libzip-1.9.2.tar.gz')
            //参考 https://stackoverflow.com/questions/15759373/static-libzip-with-visual-studio-2012
            -> setConfigureBeforeCleanPackage()
            ->withConfigureBeforeScript('echo  \'ADD_LIBRARY(zipstatic STATIC ${LIBZIP_SOURCES} ${LIBZIP_EXTRA_FILES} ${LIBZIP_OPTIONAL_FILES} ${LIBZIP_OPSYS_FILES})\'  >> lib/CMakeLists.txt ')
            ->withConfigure('cmake . -DCMAKE_INSTALL_PREFIX=/usr/zip -DLIBZIP_DO_INSTALL=OFF \
            -DENABLE_GNUTLS=OFF -DBUILD_SHARED_LIBS=OFF -DOPENSSL_USE_STATIC_LIBS=TRUE  -DENABLE_OPENSSL=ON \
            -DENABLE_ZSTD=ON -DENABLE_LZMA=ON    -DENABLE_MBEDTLS=OFF \
            -DBZIP2_LIBRARIES=/usr/bzip2/lib -DBZIP2_INCLUDE_DIR=/usr/bzip2/include ' )
            //-DLIBLZMA_LIBRARIES=/usr/liblzma/lib  -DLIBLZMA_INCLUDE_DIR=/usr/liblzma/include' )
            ->withMakeOptions('VERBOSE=1 DESTDIR=/usr/zip/ ')
            ->withPkgName('libzip')
            ->withPkgConfig('/usr/zip/lib/pkgconfig')
            ->withLdflags('-L/usr/zip/lib')
            ->withHomePage('https://libzip.org/')
            ->withLicense('https://libzip.org/license/', Library::LICENSE_BSD)
    );
}

function install_icu(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('icu'))
            ->withUrl('https://github.com/unicode-org/icu/releases/download/release-60-3/icu4c-60_3-src.tgz')
            ->withConfigure('source/runConfigureICU Linux --prefix=/usr/icu --enable-static --disable-shared')
            ->withPkgName('icu-i18n')
            ->withPkgConfig('/usr/icu/lib/pkgconfig')
            ->withLdflags('-L/usr/icu/lib')
            ->withHomePage('https://icu.unicode.org/')
            ->withLicense('https://github.com/unicode-org/icu/blob/main/icu4c/LICENSE', Library::LICENSE_SPEC)
    );
}

function install_oniguruma(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('oniguruma'))
            ->withUrl('https://codeload.github.com/kkos/oniguruma/tar.gz/refs/tags/v6.9.7')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/oniguruma --enable-static --disable-shared')
            ->withPkgConfig('/usr/oniguruma/lib/pkgconfig')
            ->withLdflags('-L/usr/oniguruma/lib')
            ->withFile('oniguruma-6.9.7.tar.gz')
            ->withLicense('https://github.com/kkos/oniguruma/blob/master/COPYING', Library::LICENSE_SPEC)
    );
}



function install_cares(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('cares'))
            ->withUrl('https://c-ares.org/download/c-ares-1.18.1.tar.gz')
            /*
            ->withConfigure('./configure --prefix=/usr/cares --enable-static --disable-shared')
            ->withPkgName('libcares')
            ->withPkgConfig('/usr/cares/lib/pkgconfig')
            ->withLdflags('-L/usr/cares/lib')
            */
            ->withConfigure('./configure --prefix=/usr/ --enable-static --disable-shared')
            ->withPkgName('libcares')
            ->disableDefaultPkgConfig()
            //->withPkgConfig('/usr/lib/pkgconfig')
            ->disableDefaultLdflags()
            //->withLdflags('-L/usr/lib')
            ->withLicense('https://c-ares.org/license.html', Library::LICENSE_MIT)
            ->withHomePage('https://c-ares.org/')
    );
}



function install_libedit(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libedit', '/usr/libedit'))
            ->withUrl('https://thrysoee.dk/editline/libedit-20210910-3.1.tar.gz')
            ->withConfigure('./configure --prefix=/usr/libedit --enable-static --disable-shared')
            ->withLdflags('')
            ->withLicense('http://www.netbsd.org/Goals/redistribution.html', Library::LICENSE_BSD)
            ->withHomePage('https://thrysoee.dk/editline/')
    );
}


function install_ncurses(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('ncurses'))
            ->withUrl('https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.3.tar.gz')
            //->withUrl('https://invisible-island.net/datafiles/release/ncurses.tar.gz')
            //->withFile('ncurses.tar.gz')
            ->withFile('ncurses-6.3.tar.gz')
            ->withConfigure('mkdir -p /usr/ncurses/lib/pkgconfig && ./configure --prefix=/usr/ncurses  --enable-widec --enable-static --disable-shared  --enable-pc-files --with-pkg-config=/usr/ncurses/lib/pkgconfig --with-pkg-config-libdir=/usr/ncurses/lib/pkgconfig') //
            ->withPkgConfig('/usr/ncurses/lib/pkgconfig')
            ->withLdflags('-L/usr/ncurses/lib')
            //->withLicense('https://github.com/projectceladon/libncurses/blob/master/README', Library::LICENSE_MIT)
            ->withLicense('https://invisible-island.net/ncurses/ncurses-license.html', Library::LICENSE_GPL)
            //->withHomePage('https://github.com/projectceladon/libncurses')
            ->withHomePage('https://invisible-island.net/ncurses/#download_ncurses')
    );
}

function install_readline(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('readline', '/usr/readline'))
            ->withUrl('ftp://ftp.cwru.edu/pub/bash/readline-8.2.tar.gz')
            ->withConfigure('env CPPFLAGS=-I/usr/ncurses/include LDFLAGS=-L/usr/ncurses/lib ./configure --prefix=/usr/readline --enable-static --disable-shared --with-curses')
            ->withPkgName('libreadline')
            ->withPkgConfig('/usr/readline/lib/pkgconfig')
            ->withLdflags('-L/usr/readline/lib')
            ->withLicense('http://www.gnu.org/licenses/gpl.html', Library::LICENSE_GPL)
            ->withHomePage('https://tiswww.case.edu/php/chet/readline/rltop.html')

    );
}

function install_libsodium(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libsodium'))
            ->withUrl('https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libsodium --enable-static --disable-shared')
            ->withPkgConfig('/usr/libsodium/lib/pkgconfig')
            ->withLdflags('-L/usr/libsodium/lib')
            // ISC License, like BSD
            ->withLicense('https://en.wikipedia.org/wiki/ISC_license', Library::LICENSE_SPEC)
            ->withHomePage('https://doc.libsodium.org/')
    );
}

function install_libyaml(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libyaml', '/usr/libyaml'))
            ->withUrl('http://pyyaml.org/download/libyaml/yaml-0.2.5.tar.gz')
            ->withConfigure('./configure --prefix=/usr/libyaml --enable-static --disable-shared')
            ->withPkgConfig('/usr/libyaml/lib/pkgconfig')
            ->withLdflags('-L/usr/libyaml/lib')
            ->withPkgName('yaml-0.1')
            ->withLicense('https://pyyaml.org/wiki/LibYAML', Library::LICENSE_MIT)
            ->withHomePage('https://pyyaml.org/wiki/LibYAML')
    );
}

function install_brotli(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('brotli', '/usr/brotli'))
            ->withUrl('https://github.com/google/brotli/archive/refs/tags/v1.0.9.tar.gz')
            ->withFile('brotli-1.0.9.tar.gz')
            ->withConfigure("cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/usr/brotli .")
            ->withPkgConfig('/usr/brotli/lib/pkgconfig')
            ->withLdflags('-L/usr/brotli/lib')
            ->withScriptAfterInstall(
                implode(PHP_EOL, [
                    'rm -rf /usr/brotli/lib/*.so.*',
                    'rm -rf /usr/brotli/lib/*.so',
                    'mv /usr/brotli/lib/libbrotlicommon-static.a /usr/brotli/lib/libbrotli.a',
                    'mv /usr/brotli/lib/libbrotlienc-static.a /usr/brotli/lib/libbrotlienc.a',
                    'mv /usr/brotli/lib/libbrotlidec-static.a /usr/brotli/lib/libbrotlidec.a',
                ]))
            ->withPkgName('libbrotlicommon libbrotlidec libbrotlienc')
            ->withLicense('https://github.com/google/brotli/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withHomePage('https://github.com/google/brotli')
    );
}

function install_curl(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('curl', '/usr/curl'))
            //->withUrl('https://curl.se/download/curl-7.80.0.tar.gz')
            ->withUrl('https://curl.se/download/curl-7.87.0.tar.gz')
            ->withConfigure(
                "autoreconf -fi && ./configure --prefix=/usr/curl --enable-static --disable-shared --with-openssl=/usr/openssl " .
                "--without-librtmp --without-brotli --without-libidn2 --disable-ldap --disable-rtsp --without-zstd --without-nghttp2 --without-nghttp3"
            )
            ->withPkgName('libcurl')
            ->withPkgConfig('/usr/curl/lib/pkgconfig')
            ->withLdflags('-L/usr/curl/lib')
            ->withLicense('https://github.com/curl/curl/blob/master/COPYING', Library::LICENSE_SPEC)
            ->withHomePage('https://curl.se/')
    );
}

function install_mimalloc(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('mimalloc', '/usr/mimalloc'))
            ->withUrl('https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.7.tar.gz')
            ->withFile('mimalloc-2.0.7.tar.gz')
            ->withConfigure("cmake . -DMI_BUILD_SHARED=OFF -DCMAKE_INSTALL_PREFIX=/usr/mimalloc -DMI_INSTALL_TOPLEVEL=ON -DMI_PADDING=OFF -DMI_SKIP_COLLECT_ON_EXIT=ON -DMI_BUILD_TESTS=OFF")
            ->withPkgName('libmimalloc')
            ->withPkgConfig('/usr/mimalloc/lib/pkgconfig')
            ->withLdflags('-L/usr/mimalloc/lib')
            ->withLicense('https://github.com/microsoft/mimalloc/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withHomePage('https://microsoft.github.io/mimalloc/')
            ->withScriptAfterInstall(implode(PHP_EOL, [
                'export PKG_CONFIG_PATH=/usr/mimalloc/lib/pkgconfig',
                'export EXTRA_LIBS=$(pkg-config --libs mimalloc)'
            ]))
    );
}




function install_postgresql(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('postgresql'))
            ->withUrl('https://ftp.postgresql.org/pub/source/v15.1/postgresql-15.1.tar.gz')
            //->withConfigure('./configure --prefix=/usr/pgsql LDFLAGS="-static" --with-ssl=openssl  --with-readline --disable-rpath --with-icu ICU_CFLAGS="-I/usr/include" ICU_LIBS="-L/usr/lib -licui18n -licuuc -licudata" --with-includes=/usr/openssl/include/openssl/:/usr/readline/include:/usr/include  --with-libraries=/usr/openssl/lib:/usr/readline/lib:/usr/lib')
            //--with-libxml XML2_CFLAGS='/usr/libxml2/include/' XML2_LIBS='/usr/libxml2/lib' \
            ->withConfigure("./configure --prefix=/usr/pgsql \
            --with-ssl=openssl  \
            --with-readline \
             --with-icu ICU_CFLAGS='-I/usr/lib/include' ICU_LIBS='-L/usr/lib -licuuc -licudata -licui18n -licuio' \
            --without-ldap \
            --with-libxml XML2_CFLAGS='-I/usr/libxml2/include/libxml2 -I/usr/libiconv/include' XML2_LIBS='-L/usr/libxml2/lib -lxml2' \
            --with-libxslt \
            --with-includes='/usr/openssl/include/:/usr/zlib/include:/usr/libxml2/include/libxml2:/usr/libxslt/include:/usr/libiconv/include:/usr/include' \
            --with-libraries='/usr/openssl/lib64:/usr/zlib/lib:/usr/libxml2/lib:/usr/libxslt/lib:L/usr/libiconv/lib:/usr/lib:/lib' \
            LDFLAGS='-static -lxslt -lz -liconv -lm -lxml2 ' "
            )
            ->withPkgConfig('/usr/pgsql/lib/pkgconfig')
            ->withLdflags('-L/usr/pgsql/lib/')

            //->withMakeOptions('-C src/interfaces')
            //->withMakeInstallOptions('-C src/interfaces') //make -C src/interfaces install
            ->withLicense('https://www.postgresql.org/about/licence/', Library::LICENSE_SPEC)
            ->withHomePage('https://www.postgresql.org/')
    );
}

//install_gettext($p);
install_libiconv($p);
install_openssl($p);
install_libxml2($p);
install_libxslt($p);
install_gmp($p);
install_zlib($p);
install_bzip2($p);

install_lzma($p);
install_zstd($p);

//install_zip($p);

install_giflib($p);
install_libpng($p);
install_libjpeg($p);
install_freetype($p);
install_libwebp($p);
install_sqlite3($p);

//install_icu($p);

install_oniguruma($p);

install_brotli($p);

install_cares($p);
//install_ncurses($p);
//install_readline($p);


//install_libedit($p);
install_imagemagick($p);
install_curl($p);
install_libsodium($p);
install_libyaml($p);
install_mimalloc($p);



//参考 https://github.com/docker-library/php/issues/221
//install_postgresql($p);


# 禁用zendOpcache
$p->disableZendOpcache();

$p->parseArguments($argc, $argv);
$p->gen();
$p->info();




