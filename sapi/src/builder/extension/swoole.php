<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = ['curl', 'openssl', 'cares', 'zlib'];

    $options = ' --enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares ';
    $options .= ' --enable-http2 ';
    $options .= ' --enable-swoole-json ';
    $options .= ' --with-openssl-dir=' . OPENSSL_PREFIX;

    $ext = (new Extension('swoole'))
        ->withHomePage('https://github.com/swoole/swoole-src')
        ->withLicense('https://github.com/swoole/swoole-src/blob/master/LICENSE', Extension::LICENSE_APACHE2)
        ->withManual('https://wiki.swoole.com/#/')
        ->withOptions($options)
        ->withUrl('https://github.com/swoole/swoole-src/archive/refs/tags/v4.8.12.tar.gz')
        ->withFile('swoole-v4.8.12.tar.gz')
        ->withDownloadScript(
            'swoole-src',
            <<<EOF
            git clone -b v4.8.12 --depth=1  https://github.com/swoole/swoole-src.git

EOF
        )
        ->withDependentExtensions('curl', 'openssl', 'sockets', 'mysqlnd', 'pdo');
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);

    $p->addExtension($ext);
};
