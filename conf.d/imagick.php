<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $libjpeg_prefix = JPEG_PREFIX;
    $lib = new Library('libjpeg');
    $lib->withHomePage('https://libjpeg-turbo.org/')
        ->withManual('https://libjpeg-turbo.org/Documentation/Documentation')
        ->withLicense('https://github.com/libjpeg-turbo/libjpeg-turbo/blob/main/LICENSE.md', Library::LICENSE_BSD)
        ->withUrl('https://codeload.github.com/libjpeg-turbo/libjpeg-turbo/tar.gz/refs/tags/2.1.2')
        ->withFile('libjpeg-turbo-2.1.2.tar.gz')
        ->withPrefix($libjpeg_prefix)
        ->withConfigure(
            <<<EOF
            cmake -G"Unix Makefiles"   . \
            -DCMAKE_INSTALL_PREFIX={$libjpeg_prefix} \
            -DCMAKE_INSTALL_LIBDIR={$libjpeg_prefix}/lib \
            -DCMAKE_INSTALL_INCLUDEDIR={$libjpeg_prefix}/include \
            -DCMAKE_BUILD_TYPE=Release  \
            -DBUILD_SHARED_LIBS=OFF  \
            -DBUILD_STATIC_LIBS=ON \
            -DENABLE_SHARED=OFF  \
            -DENABLE_STATIC=ON

EOF
        )
        ->withScriptAfterInstall(
            <<<EOF
            rm -rf {$libjpeg_prefix}/lib/*.so.*
            rm -rf {$libjpeg_prefix}/lib/*.so
            rm -rf {$libjpeg_prefix}/lib/*.dylib
EOF
        )
        ->withPkgName('libjpeg')
        ->withPkgName('libturbojpeg')
        ->withBinPath($libjpeg_prefix . '/bin/');
    $p->addLibrary($lib);

    $libpng_prefix = PNG_PREFIX;
    $libzlib_prefix = ZLIB_PREFIX;
    $p->addLibrary(
        (new Library('libpng'))
            ->withHomePage('http://www.libpng.org/pub/png/libpng.html')
            ->withLicense('http://www.libpng.org/pub/png/src/libpng-LICENSE.txt', Library::LICENSE_SPEC)
            ->withUrl('https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz')
            ->withPrefix($libpng_prefix)
            ->withConfigure(
                <<<EOF
                ./configure --help
                CPPFLAGS="$(pkg-config  --cflags-only-I  --static zlib )" \
                LDFLAGS="$(pkg-config   --libs-only-L    --static zlib )" \
                LIBS="$(pkg-config      --libs-only-l    --static zlib )" \
                ./configure --prefix={$libpng_prefix} \
                --enable-static --disable-shared \
                --with-zlib-prefix={$libzlib_prefix} \
                --with-binconfigs


EOF
            )
            ->withPkgName('libpng')
            ->withPkgName('libpng16')
            ->withBinPath($libpng_prefix . '/bin')
            ->depends('zlib')
    );

    $libgif_prefix = GIF_PREFIX;
    $p->addLibrary(
        (new Library('libgif'))
            ->withHomePage('https://giflib.sourceforge.net/')
            ->withManual('https://giflib.sourceforge.net/intro.html')
            ->withLicense('https://giflib.sourceforge.net/intro.html', Library::LICENSE_SPEC)
            ->withUrl('https://nchc.dl.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz')
            ->withPrefix($libgif_prefix)
            ->withMakeOptions('libgif.a')
            ->withMakeInstallCommand('')
            ->withScriptAfterInstall(
                <<<EOF
                if [ ! -d {$libgif_prefix}/lib ]; then
                    mkdir -p {$libgif_prefix}/lib
                fi
                if [ ! -d {$libgif_prefix}/include ]; then
                    mkdir -p {$libgif_prefix}/include
                fi
                cp libgif.a {$libgif_prefix}/lib/libgif.a
                cp gif_lib.h {$libgif_prefix}/include/gif_lib.h


EOF
            )
            ->withLdflags('-L' . $libgif_prefix . '/lib')
    );

    $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libgif_prefix . '/include');
    $p->withVariable('LDFLAGS', '$LDFLAGS -L' . $libgif_prefix . '/lib');
    $p->withVariable('LIBS', '$LIBS -lgif');

    $libwebp_prefix = WEBP_PREFIX;
    $p->addLibrary(
        (new Library('libwebp'))
            ->withHomePage('https://chromium.googlesource.com/webm/libwebp')
            ->withManual('https://chromium.googlesource.com/webm/libwebp/+/HEAD/doc/building.md')
            ->withLicense('https://github.com/webmproject/libwebp/blob/main/COPYING', Library::LICENSE_SPEC)
            ->withUrl('https://codeload.github.com/webmproject/libwebp/tar.gz/refs/tags/v1.2.1')
            ->withFile('libwebp-1.2.1.tar.gz')
            ->withPrefix($libwebp_prefix)
            ->withConfigure(
                <<<EOF
                ./autogen.sh
                ./configure --help
                CPPFLAGS="$(pkg-config  --cflags-only-I  --static libpng libjpeg )" \
                LDFLAGS="$(pkg-config --libs-only-L      --static libpng libjpeg )" \
                LIBS="$(pkg-config --libs-only-l         --static libpng libjpeg )" \
                ./configure --prefix={$libwebp_prefix} \
                --enable-static --disable-shared \
                --enable-libwebpdecoder \
                --enable-libwebpextras \
                --with-pngincludedir={$libpng_prefix}/include \
                --with-pnglibdir={$libpng_prefix}/lib \
                --with-jpegincludedir={$libjpeg_prefix}/include \
                --with-jpeglibdir={$libjpeg_prefix}/lib \
                --with-gifincludedir={$libgif_prefix}/include \
                --with-giflibdir={$libgif_prefix}/lib \
                --disable-tiff

EOF
            )
            ->withPkgName('libwebp')
            ->withLdflags('-L' . $libwebp_prefix . '/lib -lwebpdemux -lwebpmux')
            ->withBinPath($libwebp_prefix . '/bin/')
            ->depends('libpng', 'libjpeg', 'libgif')
    );

    $freetype_prefix = FREETYPE_PREFIX;
    $bzip2_prefix = BZIP2_PREFIX;
    $p->addLibrary(
        (new Library('freetype'))
            ->withHomePage('https://freetype.org/')
            ->withManual('https://freetype.org/freetype2/docs/documentation.html')
            ->withLicense(
                'https://gitlab.freedesktop.org/freetype/freetype/-/blob/master/docs/GPLv2.TXT',
                Library::LICENSE_GPL
            )
            ->withUrl('https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.gz')
            ->withPrefix($freetype_prefix)
            ->withConfigure(
                <<<EOF
            ./configure --help
            BZIP2_CFLAGS="-I{$bzip2_prefix}/include"  \
            BZIP2_LIBS="-L{$bzip2_prefix}/lib -lbz2"  \
            CPPFLAGS="$(pkg-config --cflags-only-I --static zlib libpng  libbrotlicommon  libbrotlidec  libbrotlienc)" \
            LDFLAGS="$(pkg-config  --libs-only-L   --static zlib libpng  libbrotlicommon  libbrotlidec  libbrotlienc)" \
            LIBS="$(pkg-config     --libs-only-l   --static zlib libpng  libbrotlicommon  libbrotlidec  libbrotlienc)" \
            ./configure --prefix={$freetype_prefix} \
            --enable-static \
            --disable-shared \
            --with-zlib=yes \
            --with-bzip2=yes \
            --with-png=yes \
            --with-harfbuzz=no  \
            --with-brotli=yes

EOF
            )
            ->withPkgName('freetype2')
            ->depends('zlib', 'bzip2', 'libpng', 'brotli')
    );

    $bzip2_prefix = BZIP2_PREFIX;
    $imagemagick_prefix = IMAGEMAGICK_PREFIX;
    $p->addLibrary(
        (new Library('imagemagick'))
            ->withHomePage('https://imagemagick.org/index.php')
            ->withManual('https://github.com/ImageMagick/ImageMagick.git')
            ->withLicense('https://imagemagick.org/script/license.php', Library::LICENSE_APACHE2)
            ->withUrl('https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.0-62.tar.gz')
            ->withFile('ImageMagick-v7.1.0-62.tar.gz')
            ->withMd5sum('37b896e9eecd379a6cd0d6359b9f525a')
            ->withPrefix($imagemagick_prefix)
            ->withConfigure(
                <<<EOF
            ./configure --help

            package_names="libjpeg  libturbojpeg libwebp  libwebpdecoder  libwebpdemux  libwebpmux  "
            package_names="\${package_names} libbrotlicommon libbrotlidec    libbrotlienc libcrypto libssl   openssl"

            ZIP_CFLAGS=$(pkg-config  --cflags --static libzip ) \
            ZIP_LIBS=$(pkg-config    --libs   --static libzip ) \
            ZLIB_CFLAGS=$(pkg-config  --cflags --static zlib ) \
            ZLIB_LIBS=$(pkg-config    --libs   --static zlib ) \
            LIBZSTD_CFLAGS=$(pkg-config  --cflags --static libzstd ) \
            LIBZSTD_LIBS=$(pkg-config    --libs   --static libzstd ) \
            FREETYPE_CFLAGS=$(pkg-config  --cflags --static freetype2 ) \
            FREETYPE_LIBS=$(pkg-config    --libs   --static freetype2 ) \
            LZMA_CFLAGS=$(pkg-config  --cflags --static liblzma ) \
            LZMA_LIBS=$(pkg-config    --libs   --static liblzma ) \
            PNG_CFLAGS=$(pkg-config  --cflags --static libpng ) \
            PNG_LIBS=$(pkg-config    --libs   --static libpng ) \
            WEBP_CFLAGS=$(pkg-config  --cflags --static libwebp ) \
            WEBP_LIBS=$(pkg-config    --libs   --static libwebp )  \
            WEBPMUX_CFLAGS=$(pkg-config --cflags --static libwebpmux ) \
            WEBPMUX_LIBS=$(pkg-config   --libs   --static libwebpmux ) \
            XML_CFLAGS=$(pkg-config  --cflags --static libxml-2.0 ) \
            XML_LIBS=$(pkg-config    --libs   --static libxml-2.0 ) \
            CPPFLAGS="\$(pkg-config --cflags-only-I --static \$package_names ) -I{$bzip2_prefix}/include" \
            LDFLAGS="\$(pkg-config  --libs-only-L   --static \$package_names ) -L{$bzip2_prefix}/lib"  \
            LIBS="\$(pkg-config     --libs-only-l   --static \$package_names ) -lbz2" \
            ./configure \
            --prefix={$imagemagick_prefix} \
            --enable-shared=no \
            --enable-static=yes \
            --with-zip \
            --with-zlib \
            --with-lzma \
            --with-zstd \
            --with-jpeg \
            --with-png \
            --with-webp \
            --with-xml \
            --with-freetype \
            --without-raw \
            --without-tiff \
            --without-lcms \
            --enable-zero-configuration \
            --enable-bounds-checking \
            --enable-hdri \
            --disable-dependency-tracking \
            --without-perl \
            --disable-docs \
            --disable-opencl \
            --disable-openmp \
            --without-djvu \
            --without-rsvg \
            --without-fontconfig \
            --without-heic \
            --without-jbig \
            --without-jxl \
            --without-openjp2 \
            --without-lqr \
            --without-openexr \
            --without-pango \
            --without-jbig \
            --without-x \
            --without-modules \
            --without-magick-plus-plus \
            --without-utilities
EOF
            )
            ->withPkgName('ImageMagick-7.Q16HDRI')
            ->withPkgName('ImageMagick')
            ->withPkgName('MagickCore-7.Q16HDRI')
            ->withPkgName('MagickCore')
            ->withPkgName('MagickWand-7.Q16HDRI')
            ->withPkgName('MagickWand')
            ->withBinPath($imagemagick_prefix . '/bin/')
            ->depends(
                'libxml2',
                'libzip',
                'zlib',
                'libjpeg',
                'freetype',
                'libwebp',
                'libpng',
                'libgif',
                'openssl',
                'libzstd'
            )
    );

    $p->addExtension(
        (new Extension('imagick'))
            ->withOptions('--with-imagick=' . IMAGEMAGICK_PREFIX)
            ->withPeclVersion('3.6.0')
            ->withHomePage('https://github.com/Imagick/imagick')
            ->withLicense('https://github.com/Imagick/imagick/blob/master/LICENSE', Extension::LICENSE_PHP)
            ->withMd5sum('f7b5e9b23fb844e5eb035203d316bc63')
            ->depends('imagemagick')
    );
};
