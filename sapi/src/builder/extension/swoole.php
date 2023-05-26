<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = ['curl', 'openssl', 'cares', 'zlib', 'brotli'];

    $options = ' --enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares ';
    $options .= ' --with-openssl-dir=' . OPENSSL_PREFIX;
    $options .= ' --with-brotli-dir=' . BROTLI_PREFIX;

    if ($p->getInputOption('with-swoole-pgsql')) {
        $options .= ' --enable-swoole-pgsql';
        $depends[] = 'pgsql';
    }

    $ext = (new Extension('swoole'))
        ->withHomePage('https://github.com/swoole/swoole-src')
        ->withLicense('https://github.com/swoole/swoole-src/blob/master/LICENSE', Extension::LICENSE_APACHE2)
        ->withManual('https://wiki.swoole.com/#/')
        ->withOptions($options)
        ->withFile('swoole-v4.8.x.tar.gz')
        ->withDownloadScript(
            'swoole-src',
            <<<EOF
            git clone -b 4.8.x --depth=1  https://github.com/swoole/swoole-src.git
EOF
        )
        ->withDependExtension('curl', 'openssl', 'sockets', 'mysqlnd')
    ;
    call_user_func_array([$ext, 'depends'], $depends);
    $p->addExtension($ext);
};
