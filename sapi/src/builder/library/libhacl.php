<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libhacl_prefix = LIBHACL_PREFIX;

    $lib = new Library('libhacl');
    $lib->withHomePage('https://opencv.org/')
        ->withLicense('https://github.com/hacl-star/hacl-star#Apache-2.0-1-ov-file', Library::LICENSE_APACHE2)
        ->withManual('https://github.com/opencv/opencv.git')
        ->withUrl('https://github.com/hacl-star/hacl-star/releases/download/ocaml-v0.4.5/hacl-star.0.4.5.tar.gz')
        ->withPrefix($libhacl_prefix)

        ->withBuildScript(
            <<<EOF
            make -j {$p->getMaxJob()}

EOF
        )
        //->withPkgName('example')
    ;

    $p->addLibrary($lib);


    /*

    //只有当没有 pkgconfig  配置文件才需要编写这里配置; 例子： src/builder/library/bzip2.php

    $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $libhacl_prefix . '/include');
    $p->withVariable('LDFLAGS', '$LDFLAGS -L' . $libhacl_prefix . '/lib');
    $p->withVariable('LIBS', '$LIBS -lexample ');

    */
};
