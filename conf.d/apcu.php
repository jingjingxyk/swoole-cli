<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {

    $p->addExtension(
        (new Extension('apcu'))
            ->withOptions(' --enable-apcu')
            ->withPeclVersion('5.1.22')
            ->withLicense('https://github.com/krakjoe/apcu/blob/master/LICENSE', Extension::LICENSE_PHP)
            ->withManual("https://github.com/krakjoe/apcu")
             ->withHomePage('https://pecl.php.net/package/APCu')

    );
};
