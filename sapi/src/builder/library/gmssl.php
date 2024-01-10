<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $gmssl_prefix = GMSSL_PREFIX;
    $lib = new Library('gmssl');
    $lib->withHomePage('http://gmssl.org/')
        ->withLicense('https://github.com/guanzhi/GmSSL#Apache-2.0-1-ov-file', Library::LICENSE_APACHE2)
        ->withManual('https://github.com/guanzhi/GmSSL')
        ->withUrl('https://github.com/guanzhi/GmSSL/archive/refs/tags/v3.1.1.tar.gz')
        ->withFile('GmSSL-v3.1.1.tar.gz')
        ->withPrefix($gmssl_prefix)
        ->withBuildScript(
            <<<EOF
         mkdir -p build
         cd build
         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$gmssl_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON

        cmake --build . --config Release --target install

EOF
        )
        ->withBinPath($gmssl_prefix . '/bin/')
    ;
    $p->addLibrary($lib);

    $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $gmssl_prefix . '/include');
    $p->withVariable('LDFLAGS', '$LDFLAGS -L' . $gmssl_prefix . '/lib');
    $p->withVariable('LIBS', '$LIBS -lgmssl');
};
