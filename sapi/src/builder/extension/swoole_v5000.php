<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $swoole_tag = 'v5.0.3';
    $file = "swoole-{$swoole_tag}.tar.gz";

    $dependent_libraries = ['curl', 'openssl', 'cares', 'zlib', 'brotli', 'nghttp2'];
    $dependent_extensions = ['curl', 'openssl', 'sockets', 'mysqlnd', 'pdo'];
    $options = ' --enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares ';
    $options .= ' --enable-swoole-coro-time --enable-thread-context ';

    $options .= ' --with-brotli-dir=' . BROTLI_PREFIX;
    $options .= ' --with-nghttp2-dir=' . NGHTTP2_PREFIX;

    if ($p->getInputOption('with-swoole-pgsql')) {
        $dependent_libraries[] = 'pgsql';
    }

    $ext = (new Extension('swoole_v5000'))
        ->withAliasName('swoole')
        ->withHomePage('https://github.com/swoole/swoole-src')
        ->withLicense('https://github.com/swoole/swoole-src/blob/master/LICENSE', Extension::LICENSE_APACHE2)
        ->withManual('https://wiki.swoole.com/#/')
        ->withOptions($options)
        ->withFile($file)
        ->withDownloadScript(
            'swoole-src',
            <<<EOF
            git clone -b {$swoole_tag} --depth=1 https://github.com/swoole/swoole-src.git
EOF
        )
        ->withBuildCached(false);
    ;

    call_user_func_array([$ext, 'withDependentLibraries'], $dependent_libraries);
    call_user_func_array([$ext, 'withDependentExtensions'], $dependent_extensions);

    $p->addExtension($ext);
};
