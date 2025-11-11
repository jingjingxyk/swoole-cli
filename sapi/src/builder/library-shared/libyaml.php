<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libyaml_prefix = LIBYAML_PREFIX;
    $p->addLibrary(
        (new Library('libyaml'))
            ->withHomePage('https://pyyaml.org/wiki/LibYAML')
            ->withManual('https://pyyaml.org/wiki/LibYAML')
            ->withLicense('https://pyyaml.org/wiki/LibYAML', Library::LICENSE_MIT)
            ->withUrl('https://pyyaml.org/download/libyaml/yaml-0.2.5.tar.gz')
            ->withFileHash('md5', 'bb15429d8fb787e7d3f1c83ae129a999')
            ->withPrefix(LIBYAML_PREFIX)
            ->withConfigure(
                <<<EOF
            ./configure --help ;
            ./configure \
            --prefix={$libyaml_prefix}\
            --enable-static=no \
            --enable-shared=yes \
            --with-pic
EOF
            )
            ->withPkgName('yaml-0.1')
    );
};
