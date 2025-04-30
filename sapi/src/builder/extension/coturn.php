<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'coturn'
    ];
    $ext = (new Extension('coturn'))
        ->withHomePage('https://github.com/coturn/coturn/')
        ->withManual('https://github.com/coturn/coturn/tree/master/docs')
        ->withLicense('https://github.com/coturn/coturn/blob/master/LICENSE', Extension::LICENSE_SPEC);
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('coturn', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $coturn_prefix = COTURN_PREFIX;
        $system_arch = $p->getSystemArch();
        $cmd = <<<EOF
                mkdir -p {$workdir}/bin/coturn/
                cd {$coturn_prefix}/

                cp -rf {$coturn_prefix}/*  {$workdir}/bin/coturn/

                for f in `ls {$workdir}/bin/coturn/bin/` ; do
                    echo \$f
                    # strip {$workdir}/bin/coturn/bin/\$f
                done


                cd {$workdir}/bin/
                APP_VERSION=\$({$workdir}/bin/coturn/bin/turnserver --version | tail -n 1)
                APP_NAME='coturn'
                echo \${APP_VERSION} > {$workdir}/APP_VERSION
                echo \${APP_NAME} > {$workdir}/APP_NAME

EOF;
        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            otool -L {$workdir}/bin/coturn/bin/turnserver
            tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-macos-{$system_arch}.tar.xz \${APP_NAME}/ LICENSE
EOF;
        } else {
            $cmd .= <<<EOF
            file {$workdir}/bin/coturn/bin/turnserver
            readelf -h {$workdir}/bin/coturn/bin/turnserver
            tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-linux-{$system_arch}.tar.xz \${APP_NAME}/ LICENSE
EOF;
        }
        return $cmd;
    });
};
