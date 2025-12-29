<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $curl_prefix = CURL_PREFIX;
    $zlib_prefix = ZLIB_PREFIX;
    $cares_prefix = CARES_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    // curl 7.88.0 版本开始要求 openssl 3
    $p->addLibrary(
        (new Library('curl'))
            ->withHomePage('https://curl.se/')
            ->withManual('https://curl.se/docs/install.html')
            ->withLicense('https://github.com/curl/curl/blob/master/COPYING', Library::LICENSE_SPEC)
            ->withUrl('https://github.com/curl/curl/releases/download/curl-7_78_0/curl-7.78.0.tar.gz')
            ->withPrefix($curl_prefix)
            ->withBuildCached(false)
            ->withConfigure(
                <<<EOF
            ./configure --help

            PACKAGES='openssl zlib libcares libbrotlicommon libbrotlidec libbrotlienc libzstd  '
            PACKAGES="\$PACKAGES   libidn2 libpsl " # libssh2

            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)  " \
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES)" \
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
            ./configure \
            --prefix={$curl_prefix}  \
            --enable-static=yes \
            --enable-shared=no \
            --without-librtmp \
            --disable-ldap \
            --disable-rtsp \
            --enable-http \
            --enable-alt-svc \
            --enable-hsts \
            --enable-http-auth \
            --enable-mime \
            --enable-cookies \
            --enable-doh \
            --enable-ipv6 \
            --enable-proxy  \
            --enable-websockets \
            --enable-libcurl-option \
            --enable-get-easy-options \
            --enable-file \
            --enable-mqtt \
            --enable-unix-sockets  \
            --enable-progress-meter \
            --enable-optimize \
            --with-zlib={$zlib_prefix} \
            --enable-ares={$cares_prefix} \
            --with-nghttp2 \
            --without-nghttp3 \
            --with-libidn2 \
            --without-libssh2 \
            --with-default-ssl-backend=openssl \
            --without-gnutls \
            --without-mbedtls \
            --without-wolfssl \
            --without-rustls \
            --without-bearssl \
            --disable-sspi \
            --disable-crypto-auth \
            --with-openssl={$openssl_prefix} \
            --without-amissl \
            --with-pic

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
