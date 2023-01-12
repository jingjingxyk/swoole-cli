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
    $p->setExtraLdflags(
        '-framework CoreFoundation \
     -framework SystemConfiguration \
     -undefined dynamic_lookup \
     -lwebp -licudata -licui18n -licuio
     '
    );
    //$p->setExtraOptions('--with-config-file-path=/usr/local/etc');
    $p->addEndCallback(function () use ($p) {
        file_put_contents(
            __DIR__ . '/make.sh',
            str_replace('/usr', $p->getWorkDir() . '/usr', file_get_contents(__DIR__ . '/make.sh'))
        );
    });
}

# 设置CPU核数 ; 获取CPU核数，用于 make -j $(nproc)
$p->setMaxJob(`nproc 2> /dev/null || sysctl -n hw.ncpu`); // nproc on macos ；
// `grep "processor" /proc/cpuinfo | sort -u | wc -l`

// ================================================================================================
// Library
// ================================================================================================


function install_libiconv(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libiconv', '/usr/libiconv'))
            ->withUrl('https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz')
            ->withLdflags('-L/usr/libiconv/lib')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
                test -d /usr/libiconv/ && rm -rf /usr/libiconv/
            '
            )
            ->withConfigure('./configure --prefix=/usr/libiconv enable_static=yes enable_shared=no')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}

function install_openssl(Preprocessor $p)
{
    $static = $p->osType === 'macos' ? '' : ' -static --static';
    $p->addLibrary(
        (new Library('openssl', '/usr/openssl'))
            ->withUrl('https://www.openssl.org/source/openssl-3.0.7.tar.gz')
            ->withFile('openssl-3.0.7.tar.gz')
            ->withCleanBuildDirectory()
            ->withConfigure(
                <<<EOF
            # ./config $static \
            ./Configure   $static  \
            no-shared --release --prefix=/usr/openssl
EOF
            )
            ->withMakeOptions('build_sw')
            ->withMakeInstallOptions('install_sw')
            ->withPkgConfig('/usr/openssl/lib64/pkgconfig')
            ->withPkgName('libcrypto libssl openssl')
            ->withLdflags('-L/usr/openssl/lib64')
            ->withLicense('https://github.com/openssl/openssl/blob/master/LICENSE.txt', Library::LICENSE_APACHE2)
            ->withHomePage('https://www.openssl.org/')
    );
}

function install_openssl_1(Preprocessor $p)
{
    $static = $p->osType === 'macos' ? '' : ' -static --static';
    $p->addLibrary(
        (new Library('openssl_1'))
            ->withHomePage('https://www.openssl.org/')
            ->withLicense('https://github.com/openssl/openssl/blob/master/LICENSE.txt', Library::LICENSE_APACHE2)
            ->withUrl('https://www.openssl.org/source/openssl-1.1.1p.tar.gz')
            ->withFile('openssl-1.1.1p.tar.gz')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
                test -d /usr/openssl && rm -rf /usr/openssl
            '
            )
            ->withConfigure(
                <<<EOF
            ./config $static \
            no-shared --release --prefix=/usr/openssl
EOF
            )
            ->withMakeInstallOptions('install_sw')
            ->withPkgConfig('/usr/openssl/lib/pkgconfig')
            ->withPkgName('libcrypto libssl openssl')
            ->withLdflags('-L/usr/openssl/lib')
            ->withSkipInstall()
    );
}


// Dependent libiconv
function install_libxml2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libxml2'))
            ->withUrl('https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.9.10/libxml2-v2.9.10.tar.gz')
            ->withConfigure(
                '
            ./autogen.sh
            # ./configure --help
            ./configure \
            --prefix=/usr/libxml2 \
            --with-iconv=/usr/libiconv \
            --without-python \
            --enable-static=yes \
            --enable-shared=no
            '
            )
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
            ->withConfigure(
                '
            ./autogen.sh && ./configure \
            --prefix=/usr/libxslt   --enable-static=yes --enable-shared=no'
            )
            ->withPkgConfig('/usr/libxslt/lib/pkgconfig')
            ->withPkgName('libexslt libxslt')
            ->withLdflags('-L/usr/libxslt/lib')
            ->withLicense('http://www.opensource.org/licenses/mit-license.html', Library::LICENSE_MIT)
    );
}

function install_gmp(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('gmp', '/usr/gmp'))
            //站点SSL证书过期
            //->withUrl('https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz')
            //->withUrl('https://mirrors.aliyun.com/gnu/gmp/gmp-6.2.1.tar.lz')
            ->withUrl('https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.lz')
            ->withConfigure('./configure --prefix=/usr/gmp --enable-static --disable-shared')
            ->withPkgConfig('/usr/gmp/lib/pkgconfig')
            ->withPkgName('gmp')
            ->withLdflags('-L/usr/gmp/lib')
            ->withHomePage('https://www.gnu.org/software/software.html')
            ->withHomePage('https://gmplib.org/') //站点SSL证书过期
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}


function install_icu(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('icu'))
            ->withHomePage('https://icu.unicode.org/')
            ->withLicense('https://github.com/unicode-org/icu/blob/main/icu4c/LICENSE', Library::LICENSE_SPEC)
            ->withUrl('https://github.com/unicode-org/icu/releases/download/release-60-3/icu4c-60_3-src.tgz')
            //->withUrl('https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-72_1-src.tgz')
            //https://unicode-org.github.io/icu/userguide/icu4c/build.html
            ->withCleanBuildDirectory()
            ->withConfigure(
                '
            source/runConfigureICU Linux --help
            # CPPFLAGS="-DPIC -fPIC -DICU_DATA_DIR=/usr/"
            
            source/runConfigureICU Linux --prefix=/usr/ \
            --enable-static=yes \
            --enable-shared=no \
            --with-data-packaging=static \
            --enable-release=yes \
            --enable-extras=yes \
            --enable-icuio=yes \
            --enable-icu-config=yes \
            --enable-dyload=no \
            --enable-tools=yes \
            --enable-tests=no \
            --enable-samples=no
            '
            )
            ->withMakeOptions('all VERBOSE=1')
            ->withPkgName('icu-uc icu-io icu-i18n')
            ->withPkgConfig('/usr/lib/pkgconfig')
            ->withLdflags('-L/usr/lib')
            ->withBinPath("/usr/bin")
            ->withSkipInstall()
    );
}

function install_icu_2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('icu_2'))
            ->withHomePage('https://icu.unicode.org/')
            ->withLicense('https://github.com/unicode-org/icu/blob/main/icu4c/LICENSE', Library::LICENSE_SPEC)
            //->withUrl('https://github.com/unicode-org/icu/releases/download/release-60-3/icu4c-60_3-src.tgz')
            ->withUrl('https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-72_1-src.tgz')
            ->withManual("https://unicode-org.github.io/icu/userguide/icu4c/build.html")
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure('
                test -d /usr/icu && rm -rf /usr/icu
            ')
            ->withConfigure(
                '
            source/runConfigureICU Linux --help
            
            # CPPFLAGS="-DU_CHARSET_IS_UTF8=1 -DU_USING_ICU_NAMESPACE=0"  \
            
            source/runConfigureICU Linux --prefix=/usr/icu \
            --enable-static=yes \
            --enable-shared=no \
            --with-data-packaging=static \
            --enable-release=yes \
            --enable-extras=yes \
            --enable-icuio=yes \
            --enable-icu-config=yes \
            --enable-dyload=no \
            --enable-tools=yes \
            --enable-tests=no \
            --enable-samples=no
            '
            )
            ->withMakeOptions('all VERBOSE=1')
            ->withPkgName('icu-uc icu-io icu-i18n')
            ->withPkgConfig('/usr/icu/lib/pkgconfig')
            ->withLdflags('-L/usr/icu/lib')
//            ->disablePkgName()
//            ->disableDefaultPkgConfig()
//            ->disableDefaultLdflags()
            ->withSkipInstall()
    );
}


function install_pcre2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('pcre2', '/usr/pcre2'))
            ->withUrl('https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.gz')
            ->withFile('pcre2-10.42.tar.gz')
            ->withSkipInstall()
            //  CFLAGS='-static -O2 -Wall'
            ->withConfigure(
                "
            ./configure --help

            ./configure \
            --prefix=/usr/pcre2 \
            --enable-static \
            --disable-shared \
            --enable-pcre2-16 \
            --enable-pcre2-32 \
            --enable-jit \
            --enable-unicode

         "
            )
            ->withMakeInstallOptions('install ')
            //->withPkgConfig('/usr/pcre2/lib/pkgconfig')
            ->disableDefaultPkgConfig()
            //->withPkgName("libpcre2-16     libpcre2-32    libpcre2-8      libpcre2-posix")
            ->disablePkgName()
            //->withLdflags('-L/usr/pcre2/lib')
            ->disableDefaultLdflags()
            ->withLicense(
                'https://github.com/PCRE2Project/pcre2/blob/master/COPYING',
                Library::LICENSE_PCRE2
            ) //PCRE2 LICENCE
            ->withHomePage('https://github.com/PCRE2Project/pcre2.git')
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
            ->withSkipInstall()
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
                test -d /usr/ncurses && rm -rf /usr/ncurses ;
                test -d /usr/ncurses/ && rm -rf /usr/ncurses/ ;
                mkdir -p /usr/ncurses/lib/pkgconfig
            '
            )
            // CFLAGS="-static -O2 -Wall" \
            //   LDFLAGS="-Wl,R-lncurses"
            // LDFLAGS="-lncurses" \
            ->withConfigure(
                '
            ./configure --help

            # CFLAGS=$(pkg-config --cflags libpcre2-16     libpcre2-32    libpcre2-8 libpcre2-posix)
            # LDFLAGS=$(pkg-config  --libs libpcre2-16     libpcre2-32    libpcre2-8  libpcre2-posix)

            #   --with-pcre2 \ --with-curses-h

            #   --enable-widec \
            # --enable-overwrite \

            ./configure \
            --prefix=/usr/ncurses \
            --enable-static \
            --disable-shared \
            --enable-pc-files \
            --enable-echo \
            --with-normal \
            --with-pkg-config=/usr/ncurses/lib/pkgconfig \
            --with-pkg-config-libdir=/usr/ncurses/lib/pkgconfig \
            --with-ticlib \
            --without-tests \
            --without-dlsym \
            --without-debug \
            --disable-relink

            '
            )
            /*
                --enable-overwrite\
            -with-form-libname=form \
              --with-menu-libname=menu \
              --with-panel-libname=panel \
              --with-cxx-libname=ncurses
             */
            ->withScriptAfterInstall(
                "
            tic -x
            # ln -s /usr/ncurses/include/ncursesw /usr/ncurses/include/ncurses ;
:<<'EOF'
            ln -s /usr/ncurses/lib/pkgconfig/formw.pc /usr/ncurses/lib/pkgconfig/form.pc ;
            ln -s /usr/ncurses/lib/pkgconfig/menuw.pc /usr/ncurses/lib/pkgconfig/menu.pc ;
            ln -s /usr/ncurses/lib/pkgconfig/ncursesw.pc /usr/ncurses/lib/pkgconfig/ncurses.pc ;
            ln -s /usr/ncurses/lib/pkgconfig/panelw.pc /usr/ncurses/lib/pkgconfig/panel.pc ;
            ln -s /usr/ncurses/lib/pkgconfig/ncurses++w.pc /usr/ncurses/lib/pkgconfig/ncurses++.pc ;
            ln -s /usr/ncurses/lib/pkgconfig/tinfow.pc /usr/ncurses/lib/pkgconfig/tinfow.pc ;

            ln -s /usr/ncurses/lib/libformw.a /usr/ncurses/lib/libform.a ;
            ln -s /usr/ncurses/lib/libmenuw.a /usr/ncurses/lib/libmenu.a ;
            ln -s /usr/ncurses/lib/libncursesw.a /usr/ncurses/lib/libncurses.a ;
            ln -s /usr/ncurses/lib/libpanelw.a /usr/ncurses/lib/libpanel.a ;
            ln -s /usr/ncurses/lib/libtinfow.a /usr/ncurses/lib/libtinfo.a ;
EOF
                "
            )
            ->withMakeOptions('all')
            ->withPkgName('ncursesw ncurses')
            ->disablePkgName()
            //->withPkgConfig('/usr/ncurses/lib/pkgconfig')
            ->disableDefaultPkgConfig()
            //->withLdflags('-L/usr/ncurses/lib/')
            ->disableDefaultLdflags()
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
            ->withUrl('https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz')
            ->withSkipInstall()
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                <<<'_EOF_'
                 test -d /usr/readline && rm -rf /usr/readline ;

_EOF_
            )
            ->withConfigure(
                '
             # -lncurses
             # -I/usr/include/ncursesw
               ./configure --help
:<<\'EOF\'
                CFLAGS=$(pkg-config --cflags  formw menuw ncursesw  panelw )
                CFLAGS=$(pkg-config --cflags  form menu ncurses  panel )
                CFLAGS="-I/usr/ncurses/include"
                export CFLAGS="${CFLAGS} -DNCURSES_WIDECHAR"
                LDFLAGS=$(pkg-config --libs formw menuw ncursesw  panelw )
                LDFLAGS=$(pkg-config --libs form menu ncurses  panel )
                LDFLAGS="-L/usr/ncurses/lib -lformw -lmenuw -lncursesw -lpanelw -ltinfow"
                 export LDFLAGS="${LDFLAGS} -Wl,--as-needed,-O1,--sort-common "
                # -lformw -lmenuw -lncursesw  -lpanelw -Wl,--as-needed,-O1,--sort-common
               # return 0
EOF
            ./configure --prefix=/usr/readline \
            --enable-static --disable-shared --with-curses --enable-multibyte

            '
            )
            ->withMakeInstallOptions("install-static")
            ->withPkgName('readline')
            //->disablePkgName()
            //->withPkgConfig('/usr/readline/lib/pkgconfig')
            ->disableDefaultPkgConfig()
            //->withLdflags('-L/usr/readline/lib')
            ->disableDefaultLdflags()
            ->withScriptAfterInstall(
                '
            '
            )
            ->withLicense('http://www.gnu.org/licenses/gpl.html', Library::LICENSE_GPL)
            ->withHomePage('https://tiswww.case.edu/php/chet/readline/rltop.html')
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
            ->withPkgName('zlib')
            ->withLdflags('-L/usr/zlib/lib')
            ->withHomePage('https://zlib.net/')
            ->withLicense('https://zlib.net/zlib_license.html', Library::LICENSE_SPEC)
    );
}

function install_bzip2_dev_latest(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('bzip2', '/usr/bzip2'))
            ->withUrl('https://gitlab.com/bzip2/bzip2/-/archive/master/bzip2-master.tar.gz')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
              test -d /usr/bzip2 && rm -rf /usr/bzip2 ;
              apk add python3 py3-pip && python3 -m pip install pytest ;
              mkdir build && cd build ;
            '
            )
            ->withConfigure(
                '
                    cmake .. -DCMAKE_BUILD_TYPE="Release" \
                    -DCMAKE_INSTALL_PREFIX=/usr/bzip2  \
                    -DENABLE_STATIC_LIB=ON ;
                    cmake --build . --target install   ;
                    cd - ;
                    :; #  shell空语句
                    pwd
                    return 0 ; # 返回本函数调用处，本函数后续代码不在执行
            '
            )
            ->withLdflags('-L/usr/bzip2/lib')
            ->withHomePage('https://www.sourceware.org/bzip2/')
            ->withLicense('https://www.sourceware.org/bzip2/', Library::LICENSE_BSD)
    );
}


function install_bzip2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('bzip2', '/usr/bzip2'))
            ->withUrl('https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
                test -d /usr/bzip2 && rm -rf /usr/bzip2 ;
                echo $?
            '
            )
            //->withConfigure('return 0 ')
            ->withMakeOptions('all')
            ->withMakeInstallOptions(' install PREFIX=/usr/bzip2')
            ->disableDefaultPkgConfig()
            ->withLdflags('-L/usr/bzip2/lib')
            ->withHomePage('https://www.sourceware.org/bzip2/')
            ->withLicense('https://www.sourceware.org/bzip2/', Library::LICENSE_BSD)
    );
}

function install_liblz4(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('liblz4'))
            ->withUrl('https://github.com/lz4/lz4/archive/refs/tags/v1.9.4.tar.gz')
            ->withFile('lz4-v1.9.4.tar.gz')
            ->withPkgName('liblz4')
            ->withScriptBeforeConfigure("test -d /usr/liblz4/ && rm -rf /usr/liblz4/ ;")
            ->withMakeInstallOptions("prefix=/usr/liblz4/ install ")
            ->withPkgConfig('/usr/liblz4/lib/pkgconfig')
            ->withLdflags('-L/usr/liblz4/lib')
            ->withHomePage('https://github.com/lz4/lz4.git')
            ->withLicense('https://github.com/lz4/lz4/blob/dev/LICENSE', Library::LICENSE_GPL)
    );
}

function install_liblzma(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('liblzma'))
            ->withUrl('https://tukaani.org/xz/xz-5.2.9.tar.gz')
            ->withFile('xz-5.2.9.tar.gz')
            ->withConfigure('./configure --prefix=/usr/liblzma/ --enable-static  --disable-shared --disable-doc')
            ->withPkgName('liblzma')
            ->withPkgConfig('/usr/liblzma/lib/pkgconfig')
            ->withLdflags('-L/usr/liblzma/lib')
            ->withHomePage('https://tukaani.org/xz/')
            ->withLicense('https://git.tukaani.org/?p=xz.git;a=blob;f=COPYING', Library::LICENSE_LGPL)
    );
}

function install_libzstd(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libzstd'))
            ->withUrl('https://github.com/facebook/zstd/releases/download/v1.5.2/zstd-1.5.2.tar.gz')
            ->withFile('zstd-1.5.2.tar.gz')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
            test -d /usr/libzstd/ && rm -rf /usr/libzstd/
            mkdir build/cmake/builddir
            '
            )
            ->withConfigure(
                '
            cd build/cmake/builddir
            # cmake -LH ..
            cmake .. \
            -DCMAKE_INSTALL_PREFIX=/usr/libzstd/ \
            -DZSTD_BUILD_STATIC=ON \
            -DCMAKE_BUILD_TYPE=Release \
            -DZSTD_BUILD_CONTRIB=ON \
            -DZSTD_BUILD_PROGRAMS=OFF \
            -DZSTD_BUILD_SHARED=OFF \
            -DZSTD_BUILD_TESTS=OFF \
            -DZSTD_LEGACY_SUPPORT=ON \
            \
            -DZSTD_ZLIB_SUPPORT=ON \
            -DZLIB_INCLUDE_DIR=/usr/zlib/include \
            -DZLIB_LIBRARY=/usr/zlib/lib \
            \
            -DZSTD_LZ4_SUPPORT=ON \
            -DLIBLZ4_INCLUDE_DIR=/usr/liblz4/include \
            -DLIBLZ4_LIBRARY=/usr/liblz4/lib \
            \
            -DZSTD_LZMA_SUPPORT=ON \
            -DLIBLZMA_LIBRARY=/usr/liblzma/lib \
            -DLIBLZMA_INCLUDE_DIR=/usr/liblzma/include \
            -DLIBLZMA_HAS_AUTO_DECODER=ON\
            -DLIBLZMA_HAS_EASY_ENCODER=ON \
            -DLIBLZMA_HAS_LZMA_PRESET=ON
            '
            )
            ->withMakeOptions('lib')
            ->withMakeInstallOptions('install PREFIX=/usr/libzstd/')
            ->withPkgName('libzstd')
            ->withPkgConfig('/usr/libzstd/lib/pkgconfig')
            ->withLdflags('-L/usr/libzstd/lib')
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
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure(
                '
            test -d /usr/zip && rm -rf /usr/zip
            mkdir -p build
            cd build
            '
            )
            ->withConfigure(
                '
                 cmake ..  \
                -DCMAKE_INSTALL_PREFIX=/usr/zip  \
                -DBUILD_TOOLS=OFF \
                -DBUILD_EXAMPLES=OFF \
                -DBUILD_DOC=OFF \
                -DLIBZIP_DO_INSTALL=ON \
                -DBUILD_SHARED_LIBS=OFF \
                -DENABLE_GNUTLS=OFF  \
                -DENABLE_MBEDTLS=OFF \
                -DENABLE_OPENSSL=ON \
                -DOPENSSL_USE_STATIC_LIBS=TRUE \
                -DOPENSSL_LIBRARIES=/usr/openssl/lib64 \
                -DOPENSSL_INCLUDE_DIR=/usr/openssl/include \
                -DZLIB_LIBRARY=/usr/zlib/lib \
                -DZLIB_INCLUDE_DIR=/usr/zlib/include \
                -DENABLE_BZIP2=ON \
                -DBZIP2_LIBRARIES=/usr/bzip2/lib \
                -DBZIP2_LIBRARY=/usr/bzip2/lib \
                -DBZIP2_INCLUDE_DIR=/usr/bzip2/include \
                -DBZIP2_NEED_PREFIX=ON \
                -DENABLE_LZMA=OFF  \
                -DENABLE_ZSTD=OFF
            '
            )
            /*
                -DENABLE_LZMA=OFF  \
                -DLIBLZMA_LIBRARY=/usr/liblzma/lib \
                -DLIBLZMA_INCLUDE_DIR=/usr/liblzma/include \
                -DLIBLZMA_HAS_AUTO_DECODER=ON  \
                -DLIBLZMA_HAS_EASY_ENCODER=ON  \
                -DLIBLZMA_HAS_LZMA_PRESET=ON \
                -DENABLE_ZSTD=OFF \
                -DZstd_LIBRARY=/usr/libzstd/lib \
                -DZstd_INCLUDE_DIR=/usr/libzstd/include
             */
            ->withMakeOptions('VERBOSE=1 all  ') //VERBOSE=1
            ->withMakeInstallOptions("VERBOSE=1 install PREFIX=/usr/zip")
            ->withPkgName('libzip')
            ->withPkgConfig('/usr/zip/lib/pkgconfig')
            ->withLdflags('-L/usr/zip/lib')
            ->withHomePage('https://libzip.org/')
            ->withLicense('https://libzip.org/license/', Library::LICENSE_BSD)
    );
}


function install_giflib(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('giflib'))
            ->withUrl('https://nchc.dl.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure('sed -i "s@PREFIX = /usr/local@PREFIX = /usr/giflib@" Makefile')
            ->withMakeOptions('all')
            //->withMakeOptions('libgif.a')
            ->withMakeInstallOptions("install")
            ->withLdflags('-L/usr/giflib/lib')
            //->disableDefaultLdflags()
            ->disableDefaultPkgConfig()
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
            ->withPkgName('libpng libpng16')
            ->withLicense('http://www.libpng.org/pub/png/src/libpng-LICENSE.txt', Library::LICENSE_SPEC)
    );
}

function install_libjpeg(Preprocessor $p)
{
    $lib = new Library('libjpeg');
    $lib->withUrl('https://codeload.github.com/libjpeg-turbo/libjpeg-turbo/tar.gz/refs/tags/2.1.2')
        ->withFile('libjpeg-turbo-2.1.2.tar.gz')
        ->withConfigure('cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/libjpeg .')
        ->withLdflags('-L/usr/libjpeg/lib64')
        ->withPkgConfig('/usr/libjpeg/lib64/pkgconfig')
        ->withPkgName('libjpeg libturbojpeg')
        ->withHomePage('https://libjpeg-turbo.org/')
        ->withLicense('https://github.com/libjpeg-turbo/libjpeg-turbo/blob/main/LICENSE.md', Library::LICENSE_BSD);
    if ($p->osType === 'macos') {
        $lib->withScriptAfterInstall('find ' . $lib->prefix . ' -name \*.dylib | xargs rm -f');
    }
    $p->addLibrary($lib);
}


function install_brotli(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('brotli', '/usr/brotli'))
            ->withUrl('https://github.com/google/brotli/archive/refs/tags/v1.0.9.tar.gz')
            ->withFile('brotli-1.0.9.tar.gz')
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure('test -d /usr/brotli/ && rm -rf /usr/brotli/ ')
            ->withConfigure(
                "
                 cmake . -DCMAKE_BUILD_TYPE=Release \
                -DBUILD_SHARED_LIBS=OFF \
                -DCMAKE_INSTALL_PREFIX=/usr/brotli
            "
            )
            ->withPkgConfig('/usr/brotli/lib/pkgconfig')
            ->withPkgName('libbrotlicommon libbrotlidec libbrotlienc')
            ->withLdflags('-L/usr/brotli/lib')
            ->withScriptAfterInstall(
                '
                    rm -rf /usr/brotli/lib/*.so.*
                    rm -rf /usr/brotli/lib/*.so
                    cp -f  /usr/brotli/lib/libbrotlicommon-static.a /usr/brotli/lib/libbrotli.a
                    cp -f /usr/brotli/lib/libbrotlienc-static.a /usr/brotli/lib/libbrotlienc.a
                    cp -f /usr/brotli/lib/libbrotlidec-static.a /usr/brotli/lib/libbrotlidec.a
                '
            )
            ->withPkgName('libbrotlicommon libbrotlidec libbrotlienc')
            ->withLicense('https://github.com/google/brotli/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withHomePage('https://github.com/google/brotli')
    );
}


function install_harfbuzz(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('harfbuzz', '/usr/brotli'))
            ->withUrl('https://github.com/harfbuzz/harfbuzz/archive/refs/tags/6.0.0.tar.gz')
            ->withFile('harfbuzz-6.0.0.tar.gz')
            ->withSkipInstall()
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure('test -d /usr/harfbuzz/ && rm -rf /usr/harfbuzz/ ')
            ->withConfigure(
                "
                ls -lh
                meson help
                meson setup --help

                meson setup  build \
                --backend=ninja \
                --prefix=/usr/harfbuzz \
                --default-library=static \
                -D freetype=disabled \
                -D tests=disabled \
                -D docs=disabled  \
                -D benchmark=disabled

                meson compile -C build
                # ninja -C builddir
                meson install -C build
                # ninja -C builddir install
            "
            )
            //->withPkgConfig('/usr/harfbuzz/lib/pkgconfig')
            ->disableDefaultPkgConfig()
            //->withPkgName('libbrotlicommon libbrotlidec libbrotlienc')
            ->disablePkgName()
            //->withLdflags('-L/usr/harfbuzz/lib')
            ->disableDefaultLdflags()
            ->withScriptAfterInstall(
                '

                '
            )
            ->withPkgName('libbrotlicommon libbrotlidec libbrotlienc')
            ->withLicense('https://github.com/harfbuzz/harfbuzz/blob/main/COPYING', Library::LICENSE_MIT)
            ->withHomePage('https://github.com/harfbuzz/harfbuzz.git')
    );
}

function install_freetype(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('freetype', '/usr/freetype'))
            // 域名 mirror.yongbok.net 无 DNS 解析
            //->withUrl('https://mirror.yongbok.net/nongnu/freetype/freetype-2.10.4.tar.gz')
            ->withUrl('https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.gz')
            ->withConfigure(
                "

                export ZLIB_CFLAGS=$(pkg-config --cflags zlib) ;
                export ZLIB_LIBS=$(pkg-config --libs zlib) ;

                export BZIP2_CFLAGS='-I/usr/bzip2/include'
                export BZIP2_LIBS='-L/usr/bzip2/lib -lbz2'

                export LIBPNG_LIBS=$(pkg-config --cflags libpng libpng16) ;
                export LIBPNG_LIBS=$(pkg-config --libs libpng libpng16) ;

                # export BROTLI_CFLAGS=$(pkg-config --cflags  libbrotlidec libbrotlienc) ;
                # export BROTLI_LIBS=$(pkg-config --libs  libbrotlidec libbrotlienc) ;

                # export HARFBUZZ_CFLAGS=$(pkg-config --cflags  libbrotlidec libbrotlienc) ;
                # export HARFBUZZ_LIBS=$(pkg-config --libs  libbrotlidec libbrotlienc) ;

                ./configure --help
                # return 0
               ./configure --prefix=/usr/freetype --enable-static --disable-shared \
               --with-zlib=yes \
               --with-bzip2=yes \
               --with-png=yes \
               --with-harfbuzz=no \
               --with-brotli=no

               "
            )
            ->withScriptAfterInstall(
                '
                # 用完释放变量
            '
            )
            ->withLdflags('-L/usr/freetype/lib/')
            ->withPkgConfig('/usr/freetype/lib/pkgconfig')
            ->withHomePage('https://freetype.org/')
            ->withPkgName('freetype2')
            ->withLicense(
                'https://gitlab.freedesktop.org/freetype/freetype/-/blob/master/docs/FTL.TXT',
                Library::LICENSE_SPEC
            )
    );
}

function install_libwebp(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libwebp', '/usr/libwebp'))
            ->withUrl('https://codeload.github.com/webmproject/libwebp/tar.gz/refs/tags/v1.2.1')
            ->withFile('libwebp-1.2.1.tar.gz')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libwebp --enable-static --disable-shared')
            ->withPkgName('libwebp')
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
            ->withPkgName('sqlite3')
            ->withHomePage('https://www.sqlite.org/index.html')
            ->withLicense('https://www.sqlite.org/copyright.html', Library::LICENSE_SPEC)
    );
}


function install_oniguruma(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('oniguruma'))
            //->withUrl('https://codeload.github.com/kkos/oniguruma/tar.gz/refs/tags/v6.9.7')
            ->withUrl('https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz')
            ->withFile('oniguruma-v6.9.7.tar.gz')
            ->withConfigure(
                '
            ./autogen.sh
            ./configure \
            --prefix=/usr/oniguruma \
            --enable-static \
            --disable-shared

            '
            )
            ->withPkgConfig('/usr/oniguruma/lib/pkgconfig')
            ->withPkgName('oniguruma')
            //->disableDefaultPkgConfig()
            ->withLdflags('-L/usr/oniguruma/lib')
            //->disableDefaultLdflags()
            ->withFile('oniguruma-6.9.7.tar.gz')
            ->withLicense('https://github.com/kkos/oniguruma/blob/master/COPYING', Library::LICENSE_SPEC)
    );
}


function install_cares(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('cares'))
            ->withHomePage('https://c-ares.org/')
            ->withLicense('https://c-ares.org/license.html', Library::LICENSE_MIT)
            ->withUrl('https://c-ares.org/download/c-ares-1.18.1.tar.gz')
            ->withScriptBeforeConfigure('pwd')
            ->withConfigure('./configure --prefix=/usr/ --enable-static --disable-shared ')
            ->withPkgName('libcares')
            ->withPkgConfig('/usr/lib/pkgconfig')
            ->withLdflags('-L/usr/lib')
    );
}

function install_cares_2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('cares_2'))
            ->withHomePage('https://c-ares.org/')
            ->withLicense('https://c-ares.org/license.html', Library::LICENSE_MIT)
            ->withUrl('https://c-ares.org/download/c-ares-1.18.1.tar.gz')
            ->withScriptBeforeConfigure('pwd')
            ->withConfigure('./configure --prefix=/usr/c-ares --enable-static --disable-shared ')
            ->withPkgName('libcares')
            ->withPkgConfig('/usr/c-ares/lib/pkgconfig')
            ->withLdflags('-L/usr/c-ares/lib')
            ->withBinPath('/usr/c-ares/bin/')
            ->disableDefaultLdflags()
            ->disableDefaultPkgConfig()
            ->disablePkgName()
            ->withSkipInstall()
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


function install_imagemagick(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('imagemagick', '/usr/imagemagick'))
            ->withUrl('https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.0-53.tar.gz')
            ->withFile('ImageMagick-7.1.0-53.tar.gz')
            ->withConfigure(
                '
            test -d /usr/imagemagick && rm -rf /usr/imagemagick
            ./configure --help


            ZIP_CFLAGS=$(pkg-config --cflags libzip) ;
            ZIP_LIBS=$(pkg-config --libs libzip) ;

            ZLIB_CFLAGS=$(pkg-config --cflags zlib) ;
            ZLIB_LIBS=$(pkg-config --libs zlib) ;

            LIBZSTD_CFLAGS=$(pkg-config --cflags libzstd) ;
            LIBZSTD_LIBS=$(pkg-config --libs libzstd) ;


            FREETYPE_CFLAGS=$(pkg-config --cflags freetype2) ;
            FREETYPE_LIBS=$(pkg-config --libs freetype2) ;


            LZMA_CFLAGS=$(pkg-config --cflags liblzma) ;
            LZMA_LIBS=$(pkg-config --libs liblzma) ;


            PNG_CFLAGS=$(pkg-config --cflags libpng  libpng16) ;
            PNG_LIBS=$(pkg-config --libs libpng  libpng16) ;


            WEBP_CFLAGS=$(pkg-config --cflags libwebp ) ;
            WEBP_LIBS=$(pkg-config --libs libwebp ) ;

            WEBPMUX_CFLAGS=$(pkg-config --cflags libwebp libwebpdemux  libwebpmux) ;
            WEBPMUX_LIBS=$(pkg-config --libs libwebp libwebpdemux  libwebpmux) ;

            XML_CFLAGS=$(pkg-config --cflags libxml-2.0) ;
            XML_LIBS=$(pkg-config --libs libxml-2.0) ;

            # LIBOPENJP2_CFLAGS=$(pkg-config --cflags libjpeg libturbojpeg) ;
            # LIBOPENJP2_LIBS=$(pkg-config --libs libjpeg libturbojpeg) ;

            ./configure --prefix=/usr/imagemagick --enable-static --disable-shared \
            --with-zip=no \
            --with-jpeg=no \
            --with-fontconfig=no \
            --with-heic=no \
            --with-lcms=no \
            --with-lqr=no \
            --with-openexr=no \
            -with-openjp2=no \
            --with-pango=no \
            --with-raw=no \
            --with-tiff=no \
            --with-zstd=no \
            --with-freetype=no
            '
            )
            ->withPkgName('ImageMagick MagickWand MagickCore')
            ->withLicense('https://imagemagick.org/script/license.php', Library::LICENSE_APACHE2)
    );
}

function install_libidn2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libidn2', '/usr/libidn2'))
            ->withUrl('https://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz')
            ->withSkipInstall()
            ->withPkgConfig('')
            ->withLdflags('-L/usr/libidn2/lib')
            ->withConfigure('./configure --prefix=/usr/libidn2 enable_static=yes enable_shared=no')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}

function install_nghttp2(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('nghttp2', '/usr/nghttp2'))
            ->withUrl('https://github.com/nghttp2/nghttp2/releases/download/v1.51.0/nghttp2-1.51.0.tar.gz')
            ->withSkipInstall()
            ->withPkgConfig('')
            ->withLdflags('-L/usr/nghttp2/lib')
            ->withConfigure('./configure --prefix=/usr/nghttp2 enable_static=yes enable_shared=no')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
    );
}

function install_curl(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('curl', '/usr/curl'))
            //->withUrl('https://curl.se/download/curl-7.80.0.tar.gz')
            ->withUrl('https://curl.se/download/curl-7.87.0.tar.gz')
            ->withCleanBuildDirectory()
            ->withConfigure(
                '
                  autoreconf -fi && ./configure --prefix=/usr/curl --enable-static --disable-shared \
                 --with-openssl=/usr/openssl \
                 --without-librtmp \
                 --without-brotli \
                 --without-libidn2  \
                 --without-zstd \
                 --disable-ldap \
                 --disable-rtsp  \
                 --without-nghttp2 \
                 --without-nghttp3
            '
            )
            ->withPkgName('libcurl')
            ->withPkgConfig('/usr/curl/lib/pkgconfig')
            ->withLdflags('-L/usr/curl/lib')
            ->withLicense('https://github.com/curl/curl/blob/master/COPYING', Library::LICENSE_SPEC)
            ->withHomePage('https://curl.se/')
    );
}


function install_libsodium(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('libsodium'))
            ->withUrl('https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libsodium --enable-static --disable-shared')
            ->withPkgConfig('/usr/libsodium/lib/pkgconfig')
            ->withPkgName('libsodium')
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
            ->withPkgName('yaml-0.1')
            ->withLdflags('-L/usr/libyaml/lib')
            ->withPkgName('yaml-0.1')
            ->withLicense('https://pyyaml.org/wiki/LibYAML', Library::LICENSE_MIT)
            ->withHomePage('https://pyyaml.org/wiki/LibYAML')
    );
}


function install_mimalloc(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('mimalloc', '/usr/mimalloc'))
            ->withUrl('https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.7.tar.gz')
            ->withFile('mimalloc-2.0.7.tar.gz')
            ->withConfigure(
                '
                cmake . -DCMAKE_INSTALL_PREFIX=/usr/mimalloc \
                -DMI_BUILD_SHARED=OFF \
                -DMI_INSTALL_TOPLEVEL=ON \
                -DMI_PADDING=OFF \
                -DMI_SKIP_COLLECT_ON_EXIT=ON \
                -DMI_BUILD_TESTS=OFF
            '
            )
            ->withPkgName('mimalloc')
            ->withPkgConfig('/usr/mimalloc/lib/pkgconfig')
            ->withLdflags('-L/usr/mimalloc/lib')
            ->withLicense('https://github.com/microsoft/mimalloc/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withHomePage('https://microsoft.github.io/mimalloc/')
    );
}


function install_pgsql(Preprocessor $p)
{
    $p->addLibrary(
        (new Library('pgsql'))
            ->withHomePage('https://www.postgresql.org/')
            ->withLicense('https://www.postgresql.org/about/licence/', Library::LICENSE_SPEC)
            ->withUrl('https://ftp.postgresql.org/pub/source/v15.1/postgresql-15.1.tar.gz')
            //https://www.postgresql.org/docs/devel/installation.html
            //https://www.postgresql.org/docs/devel/install-make.html#INSTALL-PROCEDURE-MAKE
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure('
               test -d /usr/pgsql && rm -rf /usr/pgsql
            ')
            ->withConfigure(
                '
                  

            # export ICU_CFLAGS="$(pkg-config --cflags  --static icu-uc icu-io icu-i18n)"
            # export ICU_LIBS="$(pkg-config --libs --static icu-uc icu-io icu-i18n)"
            # export XML2_CFLAGS="$(pkg-config --cflags --static libxml-2.0 )"
            # export XML2_LIBS="$(pkg-config --libs --static libxml-2.0 )"

      
            
            # CFLAGS="-O2 -pipe"
            
            # -static -optl-static -optl-pthread -fPIC
            # libc++  -lstdc++  -lstdc++
            # -static -lstdc++  -fPIE -fPIC
            # -fno-rtti  rtti：RTTI（Run-Time Type Identification)
            ./configure --help
            
         
         
             # CCPFLAGS="-static -fPIE -fPIC  -Dexit=exit_BAD -Dabort=abort_BAD "
             # CCPFLAGS="-Dexit=exit_BAD -Dabort=abort_BAD -lstdc++"
             # LIBS="-lpgcommon and -lpgport"
             
       
                 
            export CPPFLAGS="-static -fPIE -fPIC -O2 -Wall "
            # export  LDFLAGS="-L/usr/openssl/lib64 -L/usr/libxslt/lib/ -L/usr/libxml2/lib/ -L/usr/zlib/lib -L/usr/lib"
            export  CPPFLAGS=$CPPFLAGS
             
            ./configure  --prefix=/usr/pgsql \
            --enable-coverage=no \
            --with-ssl=openssl  \
            --with-readline \
            --without-icu \
            --without-ldap \
            --without-libxml  \
            --without-libxslt \
            --with-includes="/usr/openssl/include/:/usr/libxml2/include/:/usr/libxslt/include:/usr/zlib/include:/usr/include" \
            --with-libraries="/usr/openssl/lib64:/usr/libxslt/lib/:/usr/libxml2/lib/:/usr/zlib/lib:/usr/lib"
           
           make -C src/interfaces/libpq -j $cpu_nums all-static-lib
          return 0 
           make -C src/interfaces/libpq installdirs
           make -C src/interfaces/libpq install-lib-pc
           make -C src/interfaces/libpq install-lib-static
           
            make  -C src/include install 
            make -C  src/bin/pg_config install
            
           rm -rf /usr/pgsql/lib/*.so.*
           rm -rf /usr/pgsql/lib/*.so
           
           # make -C src/interfaces/libpq install-lib-pc
           # make -C src/interfaces/libpq install-lib-static
           
           
           # installdirs install-lib
           
           return 0
            cat >> src/interfaces/libpq/Makefile <<"___EOF___" 
libpq.a: $(OBJS)
    ar rcs $@ $^
___EOF___
           make -C src/interfaces/libpq  libpq.a
           
           
           return 0 
           
           
            make  -C src/common all -j $cpu_nums
            make  -C src/include install 
      
            
            
            make -C src/backend all    -j $cpu_nums
            
            make -C src/port all  -j $cpu_nums
            make -C src/port install
            
            make  -C src/common install 
            
            make -C src/bin/pg_config install
      
      
            # 编译出错
            make -C src/interfaces/libpq 

          
            return 0
            '
            )
            ->withMakeOptions('-C src/common all')
            ->withMakeInstallOptions('-C src/include install ')
            ->withPkgName('libpq')
            ->withPkgConfig('/usr/pgsql/lib/pkgconfig')
            ->withLdflags('-L/usr/pgsql/lib/')
            ->withBinPath('/usr/pgsql/bin/')
            ->withScriptAfterInstall('
                
               
                
# https://stackoverflow.com/questions/29803847/how-to-download-compile-install-only-the-libpq-source-on-a-server-that-does-n


# cd src/interfaces/libpq; make; make install; cd -
# cd src/bin/pg_config; make install; cd -
# cd src/backend; make generated-headers; cd -
# cd src/include; make install; cd -


                    
                    
            '
            )

    //->withSkipInstall()
    //->disablePkgName()
    //->disableDefaultPkgConfig()
    //->disableDefaultLdflags()
    );
}

function install_socat($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('socat'))
            ->withHomePage('http://www.dest-unreach.org/socat/')
            ->withLicense('http://www.dest-unreach.org/socat/doc/README', Library::LICENSE_GPL)
            ->withUrl('http://www.dest-unreach.org/socat/download/socat-1.7.4.4.tar.gz')
            ->withConfigure(
                '
            pkg-config --cflags --static readline
            pkg-config  --libs --static readline


            ./configure --help ;

            CFLAGS=$(pkg-config --cflags --static  libcrypto  libssl    openssl readline)

            export CFLAGS="-static -O2 -Wall -fPIC $CFLAGS "
            export LDFLAGS=$(pkg-config --libs --static libcrypto  libssl    openssl readline)

            # LIBS="-static -Wall -O2 -fPIC  -lcrypt  -lssl   -lreadline"
            # CFLAGS="-static -Wall -O2 -fPIC"

            ./configure \
            --prefix=/usr/socat \
            --enable-readline \
            --enable-openssl-base=/usr/openssl
            '
            )
            ->withSkipInstall()
    );
}

function install_nettle($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('nettle'))
            ->withHomePage('https://www.lysator.liu.se/~nisse/nettle/')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html', Library::LICENSE_LGPL)
            ->withUrl('https://ftp.gnu.org/gnu/nettle/nettle-3.8.tar.gz')
            ->withFile('nettle-3.8.tar.gz')
            ->withConfigure(
                '
             ./configure --help
            ./configure \
            --prefix=/usr/nettle \
            --enable-static \
            --disable-shared
            '
            )
            ->withPkgConfig('/usr/nettle/lib/pkgconfig')
            ->withPkgName('hogweed nettle')
            ->withLdflags('/usr/nettle/lib')
            ->withSkipInstall()
    );
}

function install_libunistring($p)
{
    $p->addLibrary(
        (new Library('libunistring'))
            ->withHomePage('https://www.gnu.org/software/libunistring/')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html', Library::LICENSE_LGPL)
            ->withUrl('https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.1.1.tar.gz')
            ->withFile('libunistring-0.9.1.1.tar.gz')
            ->withConfigure(
                '
             ./configure --help
            ./configure \
            --prefix=/usr/libunistring \
            --enable-static \
            --disable-shared
            '
            )
            ->withPkgConfig('/usr/libunistring/lib/pkgconfig')
            ->withPkgName('libunistringe')
            ->withLdflags('/usr/libunistring/lib')
            ->disableDefaultPkgConfig()
            ->disablePkgName()
            ->disableDefaultLdflags()
            ->withSkipInstall()
    );
}

function install_gnu_tls($p)
{
    $p->addLibrary(
        (new Library('gnu_tls'))
            ->withHomePage('https://www.gnutls.org/')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html', Library::LICENSE_LGPL)
            ->withUrl('https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.8.tar.xz')
            ->withConfigure(
                '
            ./configure --help ;
            ./configure \
            --prefix=/usr/gnutls \
             --enable-static \
            --disable-shared \
            --without-zstd \
            --without-tpm2 \
            --without-tpm \
            --disable-doc \
            --disable-tests \
            --without-included-unistring
            '
            )
            //->withPkgConfig('/usr/gnutls/lib/pkgconfig')
            ->disableDefaultPkgConfig()
            //->withPkgName('hogweed nettle')
            ->disablePkgName()
            //->withLdflags('/usr/gnutls/lib')
            ->disableDefaultLdflags()
            ->withSkipInstall()
    );
}

function install_libuv($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('libuv'))
            ->withHomePage('https://libuv.org/')
            ->withLicense('https://github.com/libuv/libuv/blob/v1.x/LICENSE', Library::LICENSE_GPL)
            ->withUrl('https://github.com/libuv/libuv/archive/refs/tags/v1.44.2.tar.gz')
            ->withFile('libuv-v1.44.2.tar.gz')
            ->withConfigure(
                '

            sh autogen.sh
            ./configure --help ;
            ./configure \
            --prefix=/usr/libuv \
            --enable-static \
            --disable-shared
            '
            )
            ->withPkgConfig('/usr/libuv/lib/pkgconfig')
            ->withPkgName('libuv')
            ->withLdflags('/usr/libuv/lib')
            ->withSkipInstall()
    );
}

function install_libunwind($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('libunwind'))
            ->withHomePage('https://github.com/libunwind/libunwind.git')
            ->withLicense('https://github.com/libunwind/libunwind/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withUrl('https://github.com/libunwind/libunwind/releases/download/v1.6.2/libunwind-1.6.2.tar.gz')
            ->withFile('libunwind-1.6.2.tar.gz')
            ->withConfigure(
                '
             # autoreconf -i
                ./configure --prefix=PREFIX
            ./configure --help ;

            ./configure \
            --prefix=/usr/libunwind \
            --enable-static=yes \
            --enable-shared=no
            '
            )
            ->withPkgConfig('/usr/libunwind/lib/pkgconfig')
            ->withPkgName('libunwind-coredump  libunwind-generic   libunwind-ptrace    libunwind-setjmp    libunwind')
            ->withLdflags('/usr/libunwind/lib')
            ->withSkipInstall()
    );
}

function install_jemalloc($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('jemalloc'))
            ->withHomePage('http://jemalloc.net/')
            ->withLicense(
                'https://github.com/jemalloc/jemalloc/blob/dev/COPYING',
                Library::LICENSE_GPL
            )
            ->withUrl('https://github.com/jemalloc/jemalloc/archive/refs/tags/5.3.0.tar.gz')
            ->withFile('jemalloc-5.3.0.tar.gz')
            ->withConfigure(
                '

            sh autogen.sh
            ./configure --help ;

            ./configure \
            --prefix=/usr/jemalloc \
            --enable-static=yes \
            --enable-shared=no \
            --with-static-libunwind=/usr/libunwind/lib/libunwind.a
            '
            )
            ->withPkgConfig('/usr/jemalloc/lib/pkgconfig')
            ->withPkgName('jemalloc')
            ->withLdflags('/usr/jemalloc/lib')
            ->withSkipInstall()
    );
}

function install_tcmalloc($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('tcmalloc'))
            ->withHomePage('https://google.github.io/tcmalloc/overview.html')
            ->withLicense('https://github.com/google/tcmalloc/blob/master/LICENSE', Library::LICENSE_APACHE2)
            ->withUrl('https://github.com/google/tcmalloc/archive/refs/heads/master.zip')
            ->withFile('tcmalloc.zip')
            ->withUntarArchiveCommand('unzip')
            ->withCleanBuildDirectory()
            ->withConfigure(
                '
            cd  tcmalloc-master/

            bazel help
            bazel build
            return
            ./configure \
            --prefix=/usr/tcmalloc \
            --enable-static \
            --disable-shared
            '
            )
            ->withPkgConfig('/usr/tcmalloc/lib/pkgconfig')
            ->withPkgName('tcmalloc')
            ->withLdflags('/usr/tcmalloc/lib')
            ->withSkipInstall()
    );
}

function install_aria2($p)
{
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $p->addLibrary(
        (new Library('aria2c'))
            ->withHomePage('https://aria2.github.io/')
            ->withLicense('https://github.com/aria2/aria2/blob/master/COPYING', Library::LICENSE_GPL)
            ->withUrl('https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0.tar.gz')
            ->withManual('https://aria2.github.io/manual/en/html/README.html')
            ->withCleanBuildDirectory()
            ->withConfigure(
                '

            # CFLAGS=$(pkg-config --cflags --static  libcrypto  libssl    openssl readline)

            # export CFLAGS="-static -O2 -Wall -fPIC $CFLAGS "
            # export LDFLAGS=$(pkg-config --libs --static libcrypto  libssl    openssl readline)

            # LIBS="-static -Wall -O2 -fPIC  -lcrypt  -lssl   -lreadline"
            # CFLAGS="-static -Wall -O2 -fPIC"

            export ZLIB_CFLAGS=$(pkg-config --cflags --static zlib) ;
            export  ZLIB_LIBS=$(pkg-config --libs --static zlib) ;

            ./configure --help ;

             ARIA2_STATIC=yes
            ./configure \
            --with-ca-bundle="/etc/ssl/certs/ca-certificates.crt" \
            --prefix=/usr/aria2 \
            --enable-static=yes \
            --enable-shared=no \
            --enable-libaria2 \
            --with-libuv \
            --without-gnutls \
            --with-openssl \
            --with-libiconv-prefix=/usr/libiconv/ \
            --with-libz
            # --with-tcmalloc
            '
            )
            ->withSkipInstall()
    );
}
function install_bazel($p)
{
    $p->addLibrary(
        (new Library('bazel'))
            ->withHomePage('https://bazel.build')
            ->withLicense('https://github.com/bazelbuild/bazel/blob/master/LICENSE', Library::LICENSE_APACHE2)
            ->withUrl('https://github.com/bazelbuild/bazel/releases/download/6.0.0/bazel-6.0.0-linux-x86_64')
            ->withManual('https://bazel.build/install')
            ->withCleanBuildDirectory()
            ->withUntarArchiveCommand('mv')
            ->withScriptBeforeConfigure('
                test -d /usr/bazel/bin/ || mkdir -p /usr/bazel/bin/
                mv bazel /usr/bazel/bin/
                chmod a+x /usr/bazel/bin/bazel
                return 0 
            ')
            ->disableDefaultPkgConfig()
            ->disablePkgName()
            ->disableDefaultLdflags()
            ->withManual('/usr/bazel/bin/')
            ->withSkipInstall()
    );
}


install_libiconv($p); //没有 libiconv.pc 文件 不能使用 pkg-config 命令
install_openssl($p);  //openssl 3 版本
install_openssl_1($p); //openssl 1 版本 默认跳过安装

install_libxml2($p);
install_libxslt($p);
install_gmp($p);


install_icu($p); //虽然自定义安装目录，并且静态编译。但是不使用，默认仍然还是使用静态系统库
install_icu_2($p); //安装目录 /usr 默认跳过安装

install_pcre2($p); //默认跳过安装


install_ncurses($p); // 默认跳过安装，默认仍然还是使用静态系统库

install_readline($p); //默认跳过安装，默认仍然还是使用静态系统库

install_zlib($p);
install_bzip2($p); //没有 libbz2.pc 文件，不能使用 pkg-config 命令
install_liblz4($p);
install_liblzma($p);
install_libzstd($p);


install_zip($p); // zip 依赖 openssl zlib bzip2  liblzma zstd
// 上一步虽然安装里了bizp2，但是仍然需要系统提供的bzip2 ，因为需要解决BZ2_bzCompressInit 找不到的问题


install_giflib($p);
install_libpng($p);
install_libjpeg($p);

install_brotli($p);
install_harfbuzz($p); //默认跳过安装
install_libwebp($p);
install_freetype($p); //需要 zlib bzip2 libpng  brotli  HarfBuzz(不打算安装）
install_sqlite3($p);


install_oniguruma($p);


install_cares($p); //目录必须是 /usr ；swoole 使用 SWOOLE_CFLAGS 实现，目前不完全支持
install_cares_2($p); //目录必须是 /usr/c-ares ；swoole 使用 SWOOLE_CFLAGS 实现，目前不完全支持


//install_libedit($p);
install_imagemagick($p);

install_libidn2($p); //默认跳过安装
install_nghttp2($p); //默认跳过安装
install_curl($p);

install_libsodium($p);
install_libyaml($p);
install_mimalloc($p);


//参考 https://github.com/docker-library/php/issues/221
install_pgsql($p);

install_socat($p);

install_nettle($p);
install_libunistring($p); //未安装成功

install_gnu_tls($p); //未安装成功
install_libuv($p);

install_libunwind($p); //使用 libunwind 可以很方便的获取函数栈中的内容，极大的方便了对函数间调用关系的了解。
install_jemalloc($p);
install_tcmalloc($p);

install_aria2($p);
install_bazel($p);


$p->parseArguments($argc, $argv);
$p->gen();
$p->info();
