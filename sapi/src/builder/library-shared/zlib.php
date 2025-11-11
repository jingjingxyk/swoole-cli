<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $zlib_prefix = ZLIB_PREFIX;
    $p->addLibrary(
        (new Library('zlib'))
            ->withHomePage('https://zlib.net/')
            ->withLicense('https://zlib.net/zlib_license.html', Library::LICENSE_SPEC)
            ->withUrl('https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz')
            ->withFile('zlib-v1.3.1.tar.gz')
            ->withFileHash('md5', 'ddb17dbbf2178807384e57ba0d81e6a1')
            ->withPrefix($zlib_prefix)
            ->withConfigure(
                <<<EOF
            ./configure  --help
            ./configure \
            --prefix={$zlib_prefix}
EOF
            )
            ->withPkgName('zlib')
            ->withDependentLibraries('libxml2', 'bzip2')
    );
};
