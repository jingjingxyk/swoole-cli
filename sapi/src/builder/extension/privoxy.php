<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'privoxy'
    ];
    $ext = (new Extension('privoxy'))
        ->withHomePage('https://www.privoxy.org')
        ->withManual('https://www.privoxy.org/user-manual/quickstart.html')
        ->withLicense('https://www.privoxy.org/gitweb/?p=privoxy.git;a=blob_plain;f=LICENSE.GPLv3;h=f288702d2fa16d3cdf0035b15a9fcbc552cd88e7;hb=HEAD', Extension::LICENSE_GPL);
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('privoxy', function (Preprocessor $p) {
        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $installdir = $p->getGlobalPrefix();
        $privoxy_prefix = PRIVOXY_PREFIX;
        $system_arch = $p->getSystemArch();
        $cmd = <<<EOF

                cd {$privoxy_prefix}/
                ls -lh .

                strip {$privoxy_prefix}/sbin/privoxy
                APP_VERSION=$({$privoxy_prefix}/sbin/privoxy --help | grep 'Privoxy version' | awk '{print $3}')
                echo \${APP_VERSION} > {$workdir}/APP_VERSION

                cd {$privoxy_prefix}/

EOF;
        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            otool -L {$privoxy_prefix}/sbin/privoxy
            tar -cJvf {$workdir}/privoxy-\${APP_VERSION}-macos-{$system_arch}.tar.xz .
EOF;
        } else {
            $cmd .= <<<EOF
              file {$privoxy_prefix}/sbin/privoxy
              readelf -h {$privoxy_prefix}//sbin/privoxy
              tar -cJvf {$workdir}/privoxy-\${APP_VERSION}-linux-{$system_arch}.tar.xz .
EOF;
        }
        return $cmd;
    });
};

# TEST privoxy
# cd $privoxy_prefix
# ./sbin/privoxy --no-daemon etc/config
