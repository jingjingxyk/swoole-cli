<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libbson_prefix = LIBBSON_PREFIX;

    //libbson 源码 位于  https://github.com/mongodb/mongo-c-driver/tree/master/src/libbson
    $p->addLibrary(
        (new Library('libbson'))
            ->withHomePage('https://www.mongodb.com/docs/drivers/c/')
            ->withLicense('https://github.com/mongodb/mongo-c-driver/blob/master/COPYING', Library::LICENSE_APACHE2)
            ->withManual('https://mongoc.org/libmongoc/current/tutorial.html')
            ->withManual('https://www.mongoc.org/libmongoc/current/installing.html')
            ->withUrl('https://github.com/mongodb/mongo-c-driver/releases/download/1.24.1/mongo-c-driver-1.24.1.tar.gz')
            ->withFile('mongo-c-driver-1.24.1.tar.gz')
            ->withPrefix($libbson_prefix)
            ->withCleanBuildDirectory()
            ->withCleanPreInstallDirectory($libbson_prefix)
            ->withBuildScript(
                <<<EOF
             mkdir -p cmake-build
            cd cmake-build
            cmake .. \
            -DCMAKE_INSTALL_PREFIX={$libbson_prefix} \
            -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
            -DCMAKE_BUILD_TYPE=Release \
            -DBUILD_SHARED_LIBS=OFF \
            -DBUILD_STATIC_LIBS=ON \
            -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF \
            -DENABLE_STATIC=ON \
            -DENABLE_TESTS=OFF \
            -DENABLE_MONGOC=OFF


            cmake --build . --target install
EOF
            )
            ->withScriptAfterInstall(
                <<<EOF
            rm -rf {$libbson_prefix}/lib/*.so.*
            rm -rf {$libbson_prefix}/lib/*.so
            rm -rf {$libbson_prefix}/lib/*.dylib
            cp -f {$libbson_prefix}/lib/libbson-static-1.0.a  {$libbson_prefix}/lib/libbson-1.0.a
            cp -f {$libbson_prefix}/lib/pkgconfig/libbson-1.0.pc  {$libbson_prefix}/lib/libbson-1.0-origin.pc
            cp -f {$libbson_prefix}/lib/pkgconfig/libbson-static-1.0.pc  {$libbson_prefix}/lib/libbson-1.0.pc
EOF
            )
            ->withDependentLibraries('openssl', 'readline', 'zlib', 'libzstd', 'icu')
            ->withPkgName('libbson-static-1.0')
    );
};
