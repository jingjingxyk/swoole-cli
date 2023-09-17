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

            sed -i "s/-DHAVE_XPM/ /g" ext/gd/config.m4

            # sed -i '221d' ext/gd/config.m4
            # sed -i '287d' ext/gd/config.m4

EOF;

        return $cmd;
    });

    $p->withExportVariable('FREETYPE2_CFLAGS', '$(pkg-config  --cflags --static  libbrotlicommon libbrotlidec libbrotlienc freetype2 zlib libpng)');
    $p->withExportVariable('FREETYPE2_LIBS', '$(pkg-config    --libs   --static  libbrotlicommon libbrotlidec libbrotlienc freetype2 zlib libpng)');

};
