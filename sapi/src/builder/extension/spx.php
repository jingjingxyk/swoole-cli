<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $zlib_prefix = ZLIB_PREFIX;
    $p->addExtension(
        (new Extension('spx'))
            ->withOptions(' --enable-spx  --with-zlib-dir=' . $zlib_prefix)
            ->withurl('https://github.com/NoiseByNorthwest/php-spx/archive/refs/tags/v0.4.15.tar.gz')
            ->withfile('php-spx-v0.4.15.tar.gz')
            ->withHomePage('https://github.com/NoiseByNorthwest/php-spx')
            ->withLicense('https://github.com/NoiseByNorthwest/php-spx?tab=GPL-3.0-1-ov-file', Extension::LICENSE_GPL)
            ->withDependentLibraries('zlib')
    );
};
