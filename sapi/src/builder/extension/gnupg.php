<?php


use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = ['libgnupg'];
    $options = '--with-gnupg' . EXAMPLE_PREFIX;

    $ext = (new Extension('gnupg'))
        ->withLicense('https://github.com/php-gnupg/php-gnupg/blob/master/LICENSE', Extension::LICENSE_PHP)
        ->withHomePage('https://pecl.php.net/package/gnupg')
        ->withManual('https://github.com/php-gnupg/php-gnupgt')
        ->withOptions($options)
        ->withPeclVersion('1.5.1')
        ->withDependentExtensions(...$depends);
    $p->addExtension($ext);
};