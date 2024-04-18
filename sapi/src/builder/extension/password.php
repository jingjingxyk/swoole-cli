<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addExtension(
        (new Extension('password'))
            ->withOptions(' --with-password-argon2')
            ->withHomePage('https://www.php.net/manual/en/password.installation.php')
            ->withLicense('https://github.com/php/php-src/blob/master/LICENSE', Extension::LICENSE_PHP)
            ->withManual('https://www.php.net/manual/en/refs.crypto.php')
            ->withDependentLibraries('libsodium')
    );
    $p->withExportVariable('ARGON2_CFLAGS', '$(pkg-config  --cflags --static libsodium)');
    $p->withExportVariable('ARGON2_LIBS', '$(pkg-config    --libs   --static libsodium)');
};
