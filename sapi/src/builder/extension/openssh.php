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
        $openssh_prefix= OPENSSH_PREFIX;

        $cmd = <<<EOF
        cd {$builddir}/openssh/build/
        test -d release/ && rm -rf release/
        mkdir -p release/
        cp -f sshd_config.out  release/
        cp -f ssh_config.out  release/
        cp -f opensshd.init  release/

        ls -F | grep '*$' | awk -F '*' '{ print $1 }' | xargs -I {} cp {} release/
        cp -rf release/ {$workdir}/bin/openssh/

        cd {$workdir}/bin/openssh/
        ls -lha .
        rm -f config.status

        VERSION=$(./ssh -V 2>&1  | awk -F ',' '{ print $1 }' | sed 's/OpenSSH_//')
        echo \${VERSION} > {$workdir}/APP_VERSION

EOF;

        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            otool -L {$workdir}/bin/openssh/sshd
            tar -cJvf {$workdir}/openssh-\${VERSION}-macos-{$system_arch}.tar.xz .
EOF;
        } else {
            $cmd .= <<<EOF
              file {$workdir}/bin/openssh/sshd
              readelf -h {$workdir}/bin/openssh/sshd
              tar -cJvf {$workdir}/openssh-\${VERSION}-linux-{$system_arch}.tar.xz .
EOF;
        }
        return $cmd;
    });
};
