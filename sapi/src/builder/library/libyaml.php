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
            ->withPrefix($libyaml_prefix)
            ->withConfigure(
                <<<EOF
            autoreconf --install
            ./configure \
            --prefix={$libyaml_prefix} \
            --build=loongarch64-unknown-linux-gnu \
            --enable-static \
            --disable-shared
EOF
            )
            ->withPkgName('yaml-0.1')
    );
};
