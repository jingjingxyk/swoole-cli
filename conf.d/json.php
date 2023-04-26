<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('json'))
            ->withHomePage('https://www.php.net/json')
            ->withManual('https://www.php.net/json')
            ->withOptions('--enable-json')
    );
};
