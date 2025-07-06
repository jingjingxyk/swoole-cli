<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'python3'
    ];
    $ext = (new Extension('python3'))
        ->withHomePage('https://www.python.org/')
        ->withLicense('https://docs.python.org/3/license.html', Extension::LICENSE_LGPL)
        ->withManual('https://www.python.org')
        ->withManual('https://github.com/python/cpython.git')
        ->withDependentLibraries(...$depends);


    $p->addExtension($ext);
    $p->withReleaseArchive('python3', function (Preprocessor $p) {
        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $system_arch = $p->getSystemArch();
        $python3_prefix = PYTHON3_PREFIX;

        $cmd = <<<EOF
        test -d {$workdir}/bin/python3/ && rm -rf {$workdir}/bin/python3/
        mkdir -p {$workdir}/bin/python3/
        cd {$python3_prefix}/
        cp -rf {$python3_prefix}/. {$workdir}/bin/python3/

        {$workdir}/bin/python3/bin/python3.12 --version -V 2>&1 | awk '{ print $2 }'
        APP_VERSION=$({$workdir}/bin/python3/bin/python3.12 --version -V 2>&1 | awk '{ print $2 }')
        APP_NAME='python'
        echo \${APP_VERSION} > {$workdir}/APP_VERSION
        echo \${APP_NAME} > {$workdir}/APP_NAME

        cd {$workdir}/bin/python3/

EOF;

        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            file {$workdir}/bin/python3/bin/python3.12
            otool -L {$workdir}/bin/python3/bin/python3.12
            tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-macos-{$system_arch}.tar.xz .
EOF;
        } else {
            $cmd .= <<<EOF
              file {$workdir}/bin/python3/bin/python3.12
              readelf -h {$workdir}/bin/python3/bin/python3.12
              tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-linux-{$system_arch}.tar.xz .
EOF;
        }
        return $cmd;
    });
};
