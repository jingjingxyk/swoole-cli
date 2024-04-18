<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $libargon2_prefix = LIBARGON2_PREFIX;
    $p->addExtension(
        (new Extension('password'))
            ->withOptions(' --with-password-argon2=' . $libargon2_prefix)
            ->withHomePage('https://www.php.net/manual/en/password.installation.php')
            ->withLicense('https://github.com/php/php-src/blob/master/LICENSE', Extension::LICENSE_PHP)
            ->withManual('https://www.php.net/manual/en/refs.crypto.php')
            ->withDependentLibraries('libargon2')
    );
};
