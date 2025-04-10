<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $hiredis_prefix = HIREDIS_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $p->addLibrary(
        (new Library('hiredis'))
            ->withHomePage('https://github.com/redis/hiredis.git')
            ->withLicense('https://github.com/digitalocean/prometheus-client-c/blob/master/LICENSE', Library::LICENSE_GPL)
            ->withUrl('https://github.com/redis/hiredis/archive/refs/tags/v1.1.0.tar.gz')
            ->withFile('hiredis-v1.1.0.tar.gz')
            ->withPrefix($hiredis_prefix)
            //->withBuildCached(false)
            ->withConfigure(
                <<<EOF

           test -d build  && rm -rf build
           mkdir -p build
           cd build
           cmake .. \
           -DCMAKE_INSTALL_PREFIX={$hiredis_prefix} \
           -DCMAKE_BUILD_TYPE=Release \
           -DBUILD_SHARED_LIBS=OFF \
           -DBUILD_STATIC_LIBS=ON \
           -DENABLE_EXAMPLES=OFF \
           -DENABLE_ASYNC_TESTS=OFF  \
           -DENABLE_SSL=ON \
           -DDISABLE_TESTS=ON \
           -DENABLE_NUGET=OFF \
           -DCMAKE_PREFIX_PATH="{$openssl_prefix};" \
           -DCMAKE_POLICY_VERSION_MINIMUM=3.5
EOF
            )
            ->withPkgName('hiredis')
            ->withDependentLibraries('openssl')
    );
};
