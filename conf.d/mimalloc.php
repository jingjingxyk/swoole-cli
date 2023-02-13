<?php

use SwooleCli\Preprocessor;
use SwooleCli\Library;

return function (Preprocessor $p) {
    $p->addLibrary(
        (new Library('mimalloc', '/usr/mimalloc'))
            ->withUrl('https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.7.tar.gz')
            ->withFile('mimalloc-2.0.7.tar.gz')
            ->withLicense('https://github.com/microsoft/mimalloc/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withHomePage('https://microsoft.github.io/mimalloc/')
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
            ->withLdflags('-L/usr/mimalloc/lib -lmimalloc')
            ->withPkgName('mimalloc')
            ->withPkgConfig('/usr/mimalloc/lib/pkgconfig')
            ->withLdflags('-L/usr/mimalloc/lib')
    );
};

