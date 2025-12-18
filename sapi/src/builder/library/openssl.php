<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $openssl_prefix = OPENSSL_PREFIX;
    $static = $p->isMacos() ? '' : ' -static --static';

    $p->addLibrary(
        (new Library('openssl'))
            ->withHomePage('https://www.openssl.org/')
            ->withLicense('https://github.com/openssl/openssl/blob/master/LICENSE.txt', Library::LICENSE_APACHE2)
            ->withManual('https://www.openssl.org/docs/')
            ->withUrl('https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz')
            ->withPrefix($openssl_prefix)
            ->withConfigure(
                <<<EOF
                # Fix openssl error, "-ldl" should not be added when compiling statically
                sed -i.backup 's/add("-ldl", threads("-pthread"))/add(threads("-pthread"))/g' ./Configurations/10-main.conf
                # ./Configure LIST
               ./config {$static} no-shared  enable-tls1_3 --release \
               --prefix={$openssl_prefix} \
               --libdir={$openssl_prefix}/lib \
               --openssldir=/etc/ssl
EOF
            )
            ->withMakeInstallCommand('install_sw')
            ->withScriptAfterInstall(
                <<<EOF
            sed -i.backup "s/-ldl/  /g" {$openssl_prefix}/lib/pkgconfig/libcrypto.pc
EOF
            )
            ->withPkgName('libssl')
            ->withPkgName('libcrypto')
            ->withPkgName('openssl')
            ->withBinPath($openssl_prefix . '/bin/')
    );
};
