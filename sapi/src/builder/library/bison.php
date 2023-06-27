<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $bison_prefix = BISON_PREFIX;
    $libiconv_prefix= ICONV_PREFIX;
    $libreadline_prefix = READLINE_PREFIX;
    $p->addLibrary(
        (new Library('bison'))
            ->withHomePage('https://www.gnu.org/software/bison/')
            ->withUrl('https://ftpmirror.gnu.org/gnu/bison/bison-3.8.tar.gz')
            ->withLicense('https://www.gnu.org/licenses/gpl-3.0.html', Library::LICENSE_GPL)
            ->withConfigure(
                "
                    ./configure --help
                    ./configure --prefix={$bison_prefix} \
                    --with-libiconv-prefix={$libiconv_prefix} \
                    --with-libreadline-prefix={$libreadline_prefix} \
                    --without-libintl-prefix
                    "
            )
            ->withBinPath($bison_prefix . '/bin/')
    );
    $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $bison_prefix . '/include');
    $p->withVariable('LDFLAGS', '$LDFLAGS -L' . $bison_prefix . '/lib');
    $p->withVariable('LIBS', '$LIBS -ly');
};
