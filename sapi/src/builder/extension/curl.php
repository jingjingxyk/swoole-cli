<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('curl'))
            ->withHomePage('https://www.php.net/curl')
            ->withOptions('--with-curl=' . CURL_PREFIX)
            ->withDependentLibraries('curl')
    );
};
