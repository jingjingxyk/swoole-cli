<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addLibrary(
        (new Library('oniguruma'))
            ->withUrl('https://codeload.github.com/kkos/oniguruma/tar.gz/refs/tags/v6.9.7')
            ->withFile('oniguruma-6.9.7.tar.gz')
            ->withLicense('https://github.com/kkos/oniguruma/blob/master/COPYING', Library::LICENSE_SPEC)
            ->withConfigure('
            ./autogen.sh && ./configure --prefix=/usr/oniguruma --enable-static --disable-shared
            ')
            ->withPkgConfig('/usr/oniguruma/lib/pkgconfig')
            ->withPkgName('oniguruma')
            ->withLdflags('-L/usr/oniguruma/lib')
    );
    $p->addExtension((new Extension('mbstring'))
        ->withOptions('--enable-mbstring')
        ->depends('oniguruma')
    );
};
