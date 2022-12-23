<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('openssl'))
            ->withOptions('--with-openssl=/usr/openssl')
    );
};
