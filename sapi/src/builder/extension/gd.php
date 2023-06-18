<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $options = '--with-gd=' . LIBGD_PREFIX;
    $options .= ' --with-webp-dir=' . WEBP_PREFIX;
    $options .= ' --with-jpeg-dir=' . JPEG_PREFIX;
    $options .= ' --with-png-dir=' . PNG_PREFIX;
    $options .= ' --with-zlib-dir=' . ZLIB_PREFIX;
    $options .= ' --with-freetype-dir=' . FREETYPE_PREFIX;
    $options .= ' --with-xpm-dir=no';

    //$options .= ' --with-gettext=' ;
    $p->addExtension(
        (new Extension('gd'))
            ->withHomePage('https://www.php.net/manual/zh/book.image.php')
            ->withOptions($options)
            ->withDependentLibraries('libjpeg', 'freetype', 'libwebp', 'libpng', 'libgif', 'libgd2')
    );
    $p->setExtHook('gd', function (Preprocessor $p) {
        //  屏蔽 xpm 检测，替换相关行
        $workdir = $p->getWorkDir();

        $cmd = <<<EOF
                cd {$p->getPhpSrcDir()}/
                if [[ ! -f ext/gd/config.m4.backup ]] ;then
                   sed -i.backup "180c test -f ext/gd/config.m4" ext/gd/config.m4
                fi

EOF;

        return $cmd;
    });
};
