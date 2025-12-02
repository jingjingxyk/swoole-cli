<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libvpx_prefix = LIBVPX_PREFIX;
    $lib = new Library('libvpx');
    $lib->withHomePage('https://chromium.googlesource.com/webm/libvpx')
        ->withLicense('https://chromium.googlesource.com/webm/libvpx/+/refs/heads/main/LICENSE', Library::LICENSE_SPEC)
        ->withManual('https://chromium.googlesource.com/webm/libvpx/+/refs/heads/main')
        ->withFile('libvpx-v1.15.2.tar.gz')
        ->withDownloadScript(
            'libvpx',
            <<<EOF
            git clone -b v1.15.2  --depth=1  https://chromium.googlesource.com/webm/libvpx
EOF
        )
        ->withPrefix($libvpx_prefix)
        ->withBuildCached(false)
        ->withConfigure(
            <<<EOF
            ./configure --help
            ./configure \
            --prefix={$libvpx_prefix} \
            --disable-shared \
            --enable-static \
            --enable-vp8 \
            --enable-vp9 \
            --enable-pic \
            --enable-libyuv \
            --enable-internal-stats \
            --enable-postproc \
            --enable-vp9-temporal-denoising \
            --enable-vp9-highbitdepth \
            --enable-webm-io \
            --enable-tools \
            --as=auto \
            --disable-docs \
            --disable-unit-tests \
            --disable-examples

EOF
        )
        ->withPkgName('vpx')
        ->withBinPath($libvpx_prefix . '/bin/')
        ->withDependentLibraries('libwebp');

    $p->addLibrary($lib);
};
