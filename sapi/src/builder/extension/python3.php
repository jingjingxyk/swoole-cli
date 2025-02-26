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
        mkdir -p {$workdir}/bin/python3/bin/
        cd {$python3_prefix}/
        cp -f ./bin/2to3-3.12 {$workdir}/bin/python3/bin/
        cp -f ./bin/idle3.12 {$workdir}/bin/python3/bin/
        cp -f ./bin/python3.12 {$workdir}/bin/python3/bin/
        cp -f ./bin/python3.12-config {$workdir}/bin/python3/bin/


        {$workdir}/bin/python3/bin/python3.12 --version -V 2>&1 | awk '{ print $2 }'
        VERSION=$({$workdir}/bin/python3/bin/python3.12 --version -V 2>&1 | awk '{ print $2 }')
        echo \$VERSION

        cd {$workdir}/bin/python3/bin/

EOF;

        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            otool -L {$workdir}/bin/python3/bin/python3.12
            tar -cJvf {$workdir}/python-\${VERSION}-macos-{$system_arch}.tar.xz .
EOF;
        } else {
            $cmd .= <<<EOF
              file {$workdir}/bin/python3/bin/python3.12
              readelf -h {$workdir}/bin/python3/bin/python3.12
              tar -cJvf {$workdir}/python-\${VERSION}-linux-{$system_arch}.tar.xz .
EOF;
        }
        return $cmd;
    });
};
