<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $curl_prefix = CURL_PREFIX;
    $zlib_prefix = ZLIB_PREFIX;
    $cares_prefix = CARES_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $gettext_prefix = GETTEXT_PREFIX;
    $nghttp2_prefix = NGHTTP2_PREFIX;
    $libidn2_prefix = LIBIDN2_PREFIX;
    $libpsl_prefix = LIBPSL_PREFIX;

    $cppflags = "";
    $ldflags = "";
    $libs = "";

    if ($p->isMacos()) {
        $cppflags .= "-I{$gettext_prefix}/include/";
        $ldflags .= "-L{$gettext_prefix}/lib/";
        $libs .= "-lintl";
    }

    // curl 7.88.0 版本开始要求 openssl 3
    $p->addLibrary(
        (new Library('curl'))
            ->withHomePage('https://curl.se/')
            ->withManual('https://curl.se/docs/install.html')
            ->withLicense('https://github.com/curl/curl/blob/master/COPYING', Library::LICENSE_SPEC)
            ->withUrl('https://github.com/curl/curl/releases/download/curl-7_87_0/curl-7.87.0.tar.gz')
            ->withPrefix($curl_prefix)
            ->withBuildCached(false)
            ->withInstallCached(false)
            ->withBuildScript(
                <<<EOF
             mkdir -p build
             cd build

            PACKAGES='openssl zlib libcares libbrotlicommon libbrotlidec libbrotlienc libzstd  '
            PACKAGES="\$PACKAGES   libidn2 libpsl libssh2 "

            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES) {$cppflags}"
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) {$ldflags}"
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES) {$libs}"

             cmake .. \
            -DCMAKE_INSTALL_PREFIX={$curl_prefix} \
            -DCMAKE_BUILD_TYPE=Release  \
            -DBUILD_SHARED_LIBS=OFF  \
            -DCURL_DISABLE_LDAP=ON \
            -DCURL_DISABLE_LDAPS=ON \
            -DCURL_DISABLE_RTSP=ON \
            -DCURL_DISABLE_GETOPTIONS=OFF \
            -DENABLE_MANUAL=OFF \
            -DCMAKE_PREFIX_PATH="{$openssl_prefix};{$cares_prefix};{$nghttp2_prefix};{$libidn2_prefix};{$libpsl_prefix};{$zlib_prefix}" \
            -DCURL_USE_GSSAPI=OFF \
            -DOPENSSL_ROOT_DIR={$openssl_prefix} \
            -DCARES_ROOT={$cares_prefix} \
            -DBUILD_TESTING=OFF \
            -DENABLE_ARES=ON \
            -DCURL_USE_OPENSSL=ON \
            -DCURL_USE_MBEDTLS=OFF \
            -DCURL_USE_BEARSSL=OFF \
            -DCURL_USE_WOLFSSL=OFF \
            -DCURL_USE_LIBSSH2=OFF \
            -DCMAKE_VERBOSE_MAKEFILE=ON \
            -DCMAKE_C_FLAGS="\${CPPFLAGS}" \
            -DCMAKE_EXE_LINKER_FLAGS="\${LDFLAGS} \${LIBS}" \
            -DCURL_STATICLIB=ON


            cmake --build . --config Release --target install


EOF
            )
            ->withPkgName('libcurl')
            ->withBinPath($curl_prefix . '/bin/')
            ->withDependentLibraries(
                'openssl',
                'cares',
                'zlib',
                'brotli',
                'libzstd',
                'nghttp2',
                //'nghttp3',
                //'ngtcp2',
                //'libssh2',
                'libidn2',
                'libpsl'
            )
    );
};
