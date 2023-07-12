<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $taosadapter_prefix = TAOSADAPTER_PREFIX;
    $p->addLibrary(
        (new Library('taosadapter'))
            ->withHomePage('https://github.com/taosdata/taosadapter.git')
            ->withLicense('https://github.com/taosdata/TDengine/blob/main/LICENSE', Library::LICENSE_MIT)
            ->withManual('https://github.com/taosdata/taosadapter.git')
            ->withPrefix($taosadapter_prefix)
            ->withFile('taosadapter-v3.0.tar.gz')
            ->withDownloadScript(
                'taosadapter',
                <<<EOF
                git clone -b 3.0 https://github.com/taosdata/taosadapter.git
EOF
            )
            ->withBuildScript(
                <<<EOF
                export GO111MODULE=on
                export GOPROXY=https://goproxy.cn,direct
                go build
EOF
            )

    );
};
