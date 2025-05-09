<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'ovs_docs'
    ];
    $ext = (new Extension('ovs_docs'))
        ->withHomePage('https://github.com/openvswitch/ovs.git')
        ->withManual('https://github.com/openvswitch/ovs.git')
        ->withLicense('https://github.com/openvswitch/ovs/blob/master/LICENSE', Extension::LICENSE_APACHE2);
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);


    $p->withReleaseArchive('ovs_docs', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $cmd = <<<EOF
            cd {$builddir}/ovs_docs/Documentation/_build
            tar -cJvf {$workdir}/ovs-docs-latest.tar.xz .

EOF;
        return $cmd;
    });
};
