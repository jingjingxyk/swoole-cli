<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libgd_prefix = LIBGD_PREFIX;
    $libiconv_prefix = ICONV_PREFIX;
    $zlib_prefix = ZLIB_PREFIX;
    $webp_prefix = WEBP_PREFIX;
    $iconv_prefix = ICONV_PREFIX;
    $freetype_prefix = FREETYPE_PREFIX;
    $libjpeg_prefix = JPEG_PREFIX;
    $lib = new Library('libgd2');
    $lib->withHomePage('https://www.libgd.org/')
        ->withLicense('https://github.com/libgd/libgd/blob/master/COPYING', Library::LICENSE_SPEC)
        ->withUrl('https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.gz')
        ->withManual('https://github.com/libgd/libgd.git')
        ->withManual('https://libgd.github.io/pages/docs.html')
        ->withPrefix($libgd_prefix)
        ->withCleanBuildDirectory()
        ->withCleanPreInstallDirectory($libgd_prefix)
        ->withConfigure(
            <<<EOF
        mkdir -p build
        cd build
        cmake   ..  \
        -DCMAKE_INSTALL_PREFIX={$libgd_prefix} \
        -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DENABLE_GD_FORMATS=1 \
        -DENABLE_JPEG=1 \
        -DENABLE_TIFF=0 \
        -DENABLE_ICONV=1 \
        -DENABLE_FREETYPE=0 \
        -DENABLE_FONTCONFIG=0 \
        -DENABLE_WEBP=0 \
        -DENABLE_HEIF=0 \
        -DENABLE_AVIF=0 \
        -DZLIB_ROOT={$zlib_prefix} \
        -DWEBP_ROOT={$webp_prefix} \
        -DICONV_ROOT={$iconv_prefix} \
        -DJPEG_ROOT={$libjpeg_prefix} \
        -DFREETYPE_ROOT={$freetype_prefix}

        cmake --build . -- -j $(nproc)
        cmake --install .



EOF
        )
        ->withBinPath($libgd_prefix . '/bin/')
        ->withPkgName('gdlib')
        ->withDependentLibraries('zlib', 'libwebp', 'libiconv', 'libjpeg', 'freetype')
    ;

    $p->addLibrary($lib);
};
