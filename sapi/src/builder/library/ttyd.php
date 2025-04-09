<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $ttypd_prefix = TTYD_PREFIX;

    $libuv_prefix = LIBUV_PREFIX;
    $zlib_prefix = ZLIB_PREFIX;
    $libwebsockets_prefix = LIBWEBSOCKETS_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $libjson_c_prefix = LIBJSON_C_PREFIX;

    $cmake_options = "";
    if ($p->isLinux()) {
        $cmake_options .= '-DCMAKE_C_FLAGS=" -fPIE "';
        $cmake_options .= '-DCMAKE_C_LINKER_FLAGS=" -static -static-pie"';
    }
    $lib = new Library('ttyd');
    $lib->withHomePage('https://tsl0922.github.io/ttyd')
        ->withLicense('https://github.com/tsl0922/ttyd#MIT-1-ov-file', Library::LICENSE_MIT)
        ->withManual('https://github.com/tsl0922/ttyd/wiki')
        ->withFile('opencv-latest.tar.gz')
        ->withDownloadScript(
            'ttyd',
            <<<EOF
            git clone -b main  --depth=1 https://github.com/tsl0922/ttyd.git
EOF
        )
        ->withPrefix($ttypd_prefix)
        ->withInstallCached(false)
        ->withBuildCached(false)
        ->withBuildScript(
            <<<EOF
         mkdir -p build
         cd build

         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$ttypd_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
        {$cmake_options} \
        -DLWS_WITH_LIBUV=ON \
        -DOPENSSL_ROOT_DIR={$openssl_prefix} \
        -DCMAKE_PREFIX_PATH="{$libuv_prefix};{$openssl_prefix};{$zlib_prefix};{$libwebsockets_prefix};{$libuv_prefix};{$libjson_c_prefix}"


        cmake --build . --config Release

        cmake --build . --config Release --target install

EOF
        )
        ->withPkgName('libexample')
        ->withBinPath($ttypd_prefix . '/bin/')
        ->withDependentLibraries('zlib', 'openssl', 'libuv', 'libwebsockets', 'libjson_c');

    $p->addLibrary($lib);

};
