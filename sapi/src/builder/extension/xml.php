<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $options = ' --enable-libxml ';
    $options .= ' --with-libxml-dir=' . LIBXML2_PREFIX;
    $options .= ' --enable-xmlreader';
    $options .= ' --enable-xmlwriter';
    $options .= ' --enable-dom';
    $options .= ' --enable-simplexml';
    $p->addExtension(
        (new Extension('xml'))
            ->withHomePage('https://www.php.net/xml')
            ->withOptions($options)
            ->depends('libxml2')
    );
};
