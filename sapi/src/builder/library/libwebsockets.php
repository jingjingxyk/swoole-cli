<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libwebsockets_prefix = LIBWEBSOCKETS_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $libuv_prefix = LIBUV_PREFIX;
    $tag = "v4.3.5";
    $tag = "main";
    $lib = new Library('libwebsockets');
    $lib->withHomePage('https://libwebsockets.org/')
        ->withLicense('https://github.com/warmcat/libwebsockets/blob/main/LICENSE', Library::LICENSE_SPEC)
        ->withManual('https://github.com/opencv/opencv.git')
        ->withFile('libwebsockets-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'libwebsockets',
            <<<EOF
             git clone -b {$tag} --depth=1 https://github.com/warmcat/libwebsockets.git
EOF
        )
        ->withPrefix($libwebsockets_prefix)
        ->withBuildCached(false)
        ->withBuildScript(
            <<<EOF
             sed -i.bak 's/ websockets_shared//g' cmake/libwebsockets-config.cmake.in
             mkdir -p build
             cd build
             cmake .. \
            -DCMAKE_INSTALL_PREFIX={$libwebsockets_prefix} \
            -DCMAKE_BUILD_TYPE=Release  \
            -DBUILD_SHARED_LIBS=OFF  \
            -DBUILD_STATIC_LIBS=ON \
            -DCMAKE_PREFIX_PATH="{$openssl_prefix};{$libuv_prefix}" \
            -DOPENSSL_INCLUDE_DIR={$openssl_prefix}/include \
            -DOPENSSL_LIBRARY={$openssl_prefix}/lib \
            -DOPENSSL_ROOT_DIR={$openssl_prefix} \
            -DLWS_WITH_STATIC=ON \
            -DLWS_WITH_SHARED=OFF \
            -DLWS_LINK_TESTAPPS_DYNAMIC=OFF \
            -DLWS_STATIC_PIC=ON \
            -DLWS_WITH_HTTP2=ON \
            -DLWS_UNIX_SOCK=ON \
            -DLWS_IPV6=ON \
            -DLWS_WITH_LIBUV=ON \
            -DCMAKE_VERBOSE_MAKEFILE=ON \
            -DLWS_CTEST_INTERNET_AVAILABLE=OFF \
            -DLWS_WITH_MINIMAL_EXAMPLES=OFF

            cmake --build . --config Release

            cmake --build . --config Release --target install
EOF
        )
        ->withDependentLibraries('libuv', 'openssl')
        ->withScriptAfterInstall(
            <<<EOF
            rm -rf {$libwebsockets_prefix}/lib/*.so.*
            rm -rf {$libwebsockets_prefix}/lib/*.so
            rm -rf {$libwebsockets_prefix}/lib/*.dylib
EOF
        )
        ->withPkgConfig('libwebsockets');

    $p->addLibrary($lib);
};


