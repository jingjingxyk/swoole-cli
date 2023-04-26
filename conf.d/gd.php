<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {

    $options = '--with-gd=';
    $options .= ' --with-webp-dir=' . WEBP_PREFIX;
    $options .= ' --with-jpeg-dir=' . JPEG_PREFIX;
    $options .= ' --with-png-dir=' . PNG_PREFIX;
    $options .= ' --with-zlib-dir=' . ZLIB_PREFIX;
    $options .= ' --with-freetype-dir=' . FREETYPE_PREFIX;
    $options .= ' --without-libXpm';
    //$options .= ' --with-gettext=' ;

    $p->addExtension(
        (new Extension('gd'))
            ->withHomePage('https://www.php.net/manual/zh/book.image.php')
            ->withOptions($options)
            ->depends('libjpeg', 'freetype', 'libwebp', 'libpng', 'libgif')
    );
};
