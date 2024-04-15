<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $example_prefix = EXAMPLE_PREFIX;
    $hacl_prefix = EXAMPLE_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    $lib = new Library('hacl');
    $lib->withHomePage('https://github.com/hacl-star/hacl-star/')
        ->withLicense('https://github.com/hacl-star/hacl-star#Apache-2.0-1-ov-file', Library::LICENSE_APACHE2)
        ->withManual('https://github.com/hacl-star/hacl-star/')
        ->withUrl('https://github.com/hacl-star/hacl-star/releases/download/ocaml-v0.4.5/hacl-star.0.4.5.tar.gz')
        ->withPrefix($example_prefix)
        ->withBuildScript(
            <<<EOF
            ls -lh
            cd dist
            ls -lha


EOF
        );

    $p->addLibrary($lib);


    /*

    //只有当没有 pkgconfig  配置文件才需要编写这里配置; 例子： src/builder/library/bzip2.php

    $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $example_prefix . '/include');
    $p->withVariable('LDFLAGS', '$LDFLAGS -L' . $example_prefix . '/lib');
    $p->withVariable('LIBS', '$LIBS -lexample ');

    */
};
