<?php


use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $options = ' --enable-wubi  ';
    $ext = (new Extension('wubi'))
        ->withOptions($options)
        ->withLicense('https://www.php.net/license/3_01.txt', Extension::LICENSE_PHP)
        ->withHomePage('https://github.com/jingjingxyk/wubi-src')
        ->withManual('https://wubii.jingjingxyk.com/#/')
        ->withFile('wubi-latest.tar.gz')
        ->withAutoUpdateFile()
        ->withDownloadScript(
            'wubi',
            <<<EOF

        mkdir -p wubi
        cp -rf /tmp/wubi/*  ./wubi
EOF
        )
        ->withBuildCached(false);

    $p->addExtension($ext);

};
