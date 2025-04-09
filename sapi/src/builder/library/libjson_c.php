<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libjson_c_prefix = LIBJSON_C_PREFIX;
    $lib = new Library('libjson_c');
    $lib->withHomePage('https://github.com/json-c/json-c')
        ->withLicense('https://github.com/json-c/json-c?tab=readme-ov-file#License-1-ov-file', Library::LICENSE_LGPL)
        ->withManual('https://github.com/json-c/json-c')
        ->withFile('json-c-latest.tar.gz')
        ->withDownloadScript(
            'json-c',
            <<<EOF
                git clone -b master  --depth=1 https://github.com/json-c/json-c.git
EOF
        )
        ->withPrefix($libjson_c_prefix)
        ->withBuildScript(
            <<<EOF
         mkdir -p build
         cd build

         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$libjson_c_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DBUILD_TESTING=OFF \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5

        cmake --build . --config Release

        cmake --build . --config Release --target install

EOF
        )
        ->withPkgName('json-c')
        ;

    $p->addLibrary($lib);

};
