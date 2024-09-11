<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libmemcached_awesome_prefix = LIBMEMCACHED_AWESOME_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $lib = new Library('libmemcached_awesome');
    $lib->withHomePage('https://github.com/awesomized/libmemcached')
        ->withLicense('https://github.com/awesomized/libmemcached/blob/v1.x/LICENSE', Library::LICENSE_BSD)
        ->withManual('https://awesomized.github.io/libmemcached/')
        ->withUrl('https://github.com/awesomized/libmemcached/archive/refs/tags/1.1.4.tar.gz')
        ->withFile('libmemcached-awesome-1.1.4.tar.gz')
        ->withPrefix($libmemcached_awesome_prefix)
        ->withBuildScript(
            <<<EOF
         mkdir -p build
         cd build

         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$libmemcached_awesome_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DENABLE_SASL=OFF \
        -DENABLE_DTRACE=OFF \
        -DENABLE_OPENSSL_CRYPTO=OFF \
        -DCMAKE_PREFIX_PATH="{$openssl_prefix}" \
        -DBUILD_TESTING=OFF \
        -DBUILD_DOCS=OFF \
        -DENABLE_MEMASLAP=OFF


        cmake --build . --config Release --target install

EOF
        )
        ->withPkgName('libmemcached');

    $p->addLibrary($lib);
    if ($p->isLinux()) {
        # $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libmemcached_awesome_prefix . '/include/');
        # $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libmemcached_awesome_prefix . '/include/libhashkit/');
        # $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libmemcached_awesome_prefix . '/include/libhashkit-1.0/');
        # $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libmemcached_awesome_prefix . '/include/libmemcached/');
        # $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libmemcached_awesome_prefix . '/include/libmemcached-1.0/');
        $p->withVariable('LDFLAGS', '$LDFLAGS -L' . $libmemcached_awesome_prefix . '/lib');
        $p->withVariable('LIBS', '$LIBS  -lhashkit ');
    }

};
