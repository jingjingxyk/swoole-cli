<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension((new Extension('mongodb'))
        ->withOptions('--enable-mongodb')
        ->withPeclVersion('1.14.2')
        ->withManual('http://docs.mongodb.org/ecosystem/drivers/php/')
        ->withHomePage('https://www.mongodb.com/docs/drivers/php/')
    );
};
