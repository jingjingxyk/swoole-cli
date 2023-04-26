<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $options = '--enable-swoole --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares ';
    $options .= ' --with-brotli-dir=' . BROTLI_PREFIX;
    $p->addExtension(
        (new Extension('swoole'))
            ->withOptions($options)
            ->withLicense('https://github.com/swoole/swoole-src/blob/master/LICENSE', Extension::LICENSE_APACHE2)
            ->withHomePage('https://github.com/swoole/swoole-src')
            ->depends('curl', 'openssl', 'cares', 'zlib', 'brotli', 'nghttp2')
            ->withFile('swoole-4.8.x.tar.gz')
            ->withDownloadScript(
                'swoole-src',
                <<<EOF
            git clone -b 4.8.x --depth=1  https://github.com/swoole/swoole-src.git
EOF
            )

    );
};
