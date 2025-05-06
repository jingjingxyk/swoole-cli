<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $iperf3_prefix = IPERF3_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $options = '';
    if ($p->isLinux()) {
        $options .= '--enable-static-bin';
    }

    $lib = new Library('iperf3');
    $lib->withHomePage('https://github.com/esnet/iperf.git')
        ->withLicense('https://github.com/esnet/iperf/blob/master/LICENSE', Library::LICENSE_SPEC)
        ->withManual('https://github.com/esnet/iperf/blob/master/docs/building.rst')
        ->withDownloadScript(
            'iperf',
            <<<EOF
                git clone -b master  --depth=1 https://github.com/esnet/iperf.git
EOF
        )
        ->withFile('iperf3-latest.tar.gz')
        ->withPrefix($iperf3_prefix)
        ->withInstallCached(false)
        ->withConfigure(
            <<<EOF
              ./configure  --help
              ./configure  \
              --prefix={$iperf3_prefix} \
              --enable-shared=no \
              --enable-static=yes \
              --with-openssl={$openssl_prefix} \
              {$options}
EOF
        )
        ->withDependentLibraries('openssl')
    ;

    $p->addLibrary($lib);
};
