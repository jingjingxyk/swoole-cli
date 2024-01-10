<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('gmssl'))
            ->withOptions('--enable-gmssl')
            ->withUrl('https://github.com/GmSSL/GmSSL-PHP/archive/refs/tags/v1.1.0.tar.gz')
            ->withFile('gmssl-v1.1.0.tar.gz')
            ->withHomePage('https://gmssl.github.io/GmSSL-PHP/')
            ->withManual('https://github.com/GmSSL/GmSSL-PHP#License-1-ov-file')
            ->withLicense('https://github.com/GmSSL/GmSSL-PHP/blob/main/LICENSE', Extension::LICENSE_PHP)
            ->withDependentLibraries('gmssl')
    );
};
