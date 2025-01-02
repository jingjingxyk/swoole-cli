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


    $dependentLibraries = ['libjpeg', 'freetype', 'libwebp', 'libpng', 'libgif'];
    $ext = (new Extension('gd'))
        ->withHomePage('https://www.php.net/manual/zh/book.image.php')
        ->withOptions($options)
        ->withDependentLibraries(... $dependentLibraries);
    $p->addExtension($ext);


    $p->withExportVariable('FREETYPE2_CFLAGS', '$(pkg-config  --cflags --static  libbrotlicommon libbrotlidec libbrotlienc freetype2 zlib libpng)');
    $p->withExportVariable('FREETYPE2_LIBS', '$(pkg-config    --libs   --static  libbrotlicommon libbrotlidec libbrotlienc freetype2 zlib libpng)');

    $p->withBeforeConfigureScript('gd', function (Preprocessor $p) {
        //  屏蔽 xpm 检测，替换相关行
        $workdir = $p->getWorkDir();

        $cmd = <<<EOF
                cd {$p->getPhpSrcDir()}/

            sed -i "s/-DHAVE_XPM/ /g" ext/gd/config.m4

            # sed -i '221d' ext/gd/config.m4
            # sed -i '287d' ext/gd/config.m4

EOF;

        return $cmd;
    });

};
