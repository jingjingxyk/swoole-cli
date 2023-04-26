<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('hash'))
            ->withHomePage('https://www.php.net/hash')
            ->withManual('https://www.php.net/hash')
            ->withOptions('--enable-hash')
    );
};
