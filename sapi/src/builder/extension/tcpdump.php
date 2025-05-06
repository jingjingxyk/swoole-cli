<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'tcpdump'
    ];
    $ext = (new Extension('tcpdump'))
        ->withHomePage('https://www.tcpdump.org')
        ->withLicense('https://github.com/the-tcpdump-group/tcpdump?tab=License-1-ov-file#readme', Extension::LICENSE_BSD)
        ->withManual('https://github.com/the-tcpdump-group/tcpdump/blob/master/INSTALL.md');
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('tcpdump', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $system_arch = $p->getSystemArch();
        $tcpdump_prefix = TCPDUMP_PREFIX;

        $cmd = <<<EOF
                mkdir -p {$workdir}/bin/
                cp -f {$tcpdump_prefix}/bin/tcpdump {$workdir}/bin/
                APP_VERSION=\$({$workdir}/bin/tcpdump -h | head -n 1 | awk '{ print $3 }' | awk -F '-' '{ print $1 }')
                APP_NAME="tcpdump"
                echo \${APP_VERSION} > {$workdir}/APP_VERSION
                echo \${APP_NAME} > {$workdir}/APP_NAME

                cd {$workdir}/bin/

EOF;

        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            xattr -cr {$workdir}/bin/tcpdump
            otool -L {$workdir}/bin/tcpdump
            tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-macos-{$system_arch}.tar.xz tcpdump LICENSE

EOF;
        } else {
            $cmd .= <<<EOF
              file {$workdir}/bin/tcpdump
              readelf -h {$workdir}/bin/tcpdump
              tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-linux-{$system_arch}.tar.xz tcpdump LICENSE

EOF;
        }
        return $cmd;
    });
};
