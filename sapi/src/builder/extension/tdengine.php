<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {

    $options = '--with-tdengine --with-tdengine-dir=' . TDENGINE_PREFIX;

    $ext = (new Extension('tdengine'))
        ->withOptions($options)
        ->withLicense('https://github.com/Yurunsoft/php-tdengine/blob/master/LICENSE', Extension::LICENSE_SPEC)
        ->withHomePage('https://github.com/Yurunsoft/php-tdengine.git')
        ->withManual('https://wiki.swoole.com/#/')
        ->withUrl('https://github.com/Yurunsoft/php-tdengine/archive/refs/tags/v1.0.6.tar.gz')
        ->withFile('tdengine-v1.0.6.tar.gz')
        ->withDependentExtensions('swoole');
    $p->addExtension($ext);
};
