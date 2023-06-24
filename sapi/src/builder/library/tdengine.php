<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $tdengine_prefix = TDENGINE_PREFIX;
    $p->addLibrary(
        (new Library('tdengine'))
            ->withHomePage('https://docs.taosdata.com/get-started/package/#!')
            ->withUrl('https://docs.taosdata.com/get-started/package/#!')
            ->withLicense('', Library::LICENSE_SPEC)
            ->withConfigure(
                "
                    ./configure --help
                    ./configure --prefix={$tdengine_prefix}
                    "
            )
            ->withBinPath($tdengine_prefix . '/bin/')
    );
};
