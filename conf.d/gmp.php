<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addLibrary(
        (new Library('gmp', '/usr/gmp'))
            ->withUrl('https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz')
            ->withHomePage('https://gmplib.org/')
            ->withLicense('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html', Library::LICENSE_GPL)
            ->withConfigure('./configure --prefix=/usr/gmp --enable-static --disable-shared')
            ->withPkgConfig('/usr/gmp/lib/pkgconfig')
            ->withPkgName('gmp')
            ->withLdflags('-L/usr/gmp/lib')
    );
    $p->addExtension((new Extension('gmp'))->withOptions('--with-gmp=/usr/gmp')->depends('gmp'));
};
