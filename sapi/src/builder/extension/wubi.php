<?php


use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $workDir = $p->getWorkDir();
    $workExtDir = $p->getWorkExtDir();
    $options = ' --enable-wubi  ';
    $ext = (new Extension('wubi'))
        ->withOptions($options)
        ->withLicense('https://www.php.net/license/3_01.txt', Extension::LICENSE_PHP)
        ->withHomePage('https://github.com/jingjingxyk/wubi-src')
        ->withManual('https://wubi.jingjingxyk.com/#/')
        ->withFile('wubi-latest.tar.gz')
        ->withAutoUpdateFile()
        ->withDownloadScript(
            'wubi',
            <<<EOF
        cd {$workDir}/
        test -d var/wubi || mkdir -p var/wubi
        cd var
EOF
        )
        ->withBuildCached(false);
    ;
    $p->addExtension($ext);

};
