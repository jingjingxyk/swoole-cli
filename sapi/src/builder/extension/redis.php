<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('redis'))
            ->withOptions('--enable-redis')
            ->withPeclVersion('4.2.0')
            ->withHomePage('https://github.com/phpredis/phpredis')
            ->withLicense('https://github.com/phpredis/phpredis/blob/develop/COPYING', Extension::LICENSE_PHP)
            ->withDependentExtensions('session')
    );
};
