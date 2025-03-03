<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'openssl',
        'zlib',
        'openssh'
    ];
    $ext = (new Extension('openssh'))
        ->withHomePage('https://www.openssh.com/')
        ->withManual('https://anongit.mindrot.org/openssh.git/tree/')
        ->withLicense('https://anongit.mindrot.org/openssh.git/tree/LICENCE', Extension::LICENSE_SPEC);
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('openssh', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $system_arch = $p->getSystemArch();
        $openssh_prefix = OPENSSH_PREFIX;

        $cmd = <<<EOF
        cd {$openssh_prefix}/

        VERSION=$({$openssh_prefix}/sbin/sshd -V 2>&1 | awk -F ',' '{ print $1 }' | awk -F '_' '{ print $2 }')
        echo \${VERSION} > {$workdir}/APP_VERSION

        cd {$openssh_prefix}/

EOF;

        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            otool -L {$openssh_prefix}/sbin/sshd
            tar -cJvf {$workdir}/openssh-\${VERSION}-macos-{$system_arch}.tar.xz .
EOF;
        } else {
            $cmd .= <<<EOF
              file {$openssh_prefix}/sbin/sshd
              readelf -h {$openssh_prefix}/sbin/sshd
              tar -cJvf {$workdir}/openssh-\${VERSION}-linux-{$system_arch}.tar.xz .
EOF;
        }
        return $cmd;
    });
};
