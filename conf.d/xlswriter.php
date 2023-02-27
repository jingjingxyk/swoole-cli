<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension((new Extension('xlswriter'))
        ->withOptions('--enable-redis')
        ->withPeclVersion('1.5.2')
        ->withHomePage('https://github.com/viest/php-ext-xlswriter')
        ->withLicense('https://github.com/viest/php-ext-xlswriter/blob/master/LICENSE', Extension::LICENSE_BSD)
    );
};
