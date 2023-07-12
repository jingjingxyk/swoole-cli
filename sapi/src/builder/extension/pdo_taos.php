<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('pdo_taos'))
            ->withHomePage('https://github.com/bearlord/pdo_taos')
            ->withOptions('--enable-pdo_taos --with-taos-dir=' . TDENGINE_PREFIX)
            ->withurl('https://github.com/bearlord/pdo_taos/archive/refs/tags/1.0.3.tar.gz')
            ->withFile('pdo_taos_1.0.3.tgz')
            ->withDependentExtensions('pdo')
            ->withDependentLibraries('libtdengine')
    );
};
