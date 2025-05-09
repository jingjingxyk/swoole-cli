<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'ovn_docs'
    ];
    $ext = (new Extension('ovn_docs'))
        ->withHomePage('https://github.com/ovn-org/ovn.git')
        ->withManual('https://github.com/ovn-org/ovn.git') //如何选开源许可证？
        ->withLicense('https://github.com/ovn-org/ovn/blob/main/LICENSE', Extension::LICENSE_GPL)
    ;
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('ovn_docs', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $cmd = <<<EOF
            cd {$builddir}/ovn_docs/Documentation/_build
            tar -cJvf {$workdir}/ovn-docs-latest.tar.xz .
EOF;

        return $cmd;
    });
};
