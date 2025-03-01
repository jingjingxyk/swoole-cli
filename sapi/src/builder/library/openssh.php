<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $openssh_prefix = OPENSSH_PREFIX;
    $cflags = $p->getOsType() == 'macos' ? "" : '-static';
    $lib = new Library('openssh');
    $lib->withHomePage('https://www.openssh.com/')
        ->withLicense('https://anongit.mindrot.org/openssh.git/tree/LICENCE', Library::LICENSE_BSD)
        ->withManual('https://www.openssh.com/portable.html')
        ->withDocumentation('https://anongit.mindrot.org/openssh.git')
        ->withFile('openssh-V_9_9_P1.tar.gz')
        ->withHttpProxy(true, true)
        ->withDownloadScript(
            'openssh',
            <<<EOF
                git clone -b V_9_9_P1  --depth=1 git://anongit.mindrot.org/openssh.git
EOF
        )
        ->withPrefix($openssh_prefix)
        ->withBuildScript(
            <<<EOF
            autoreconf -fi
            ./configure --help
            mkdir build
            cd build
            PACKAGES='zlib openssl '
            PACKAGES="\$PACKAGES  "

            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) {$cflags}" \
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
            ../configure \
            --prefix={$openssh_prefix} \
            --with-pie

            make -j {$p->maxJob}

EOF
        )
        ->withBuildCached(false)
        ->withInstallCached(false)
        ->withDependentLibraries('openssl', 'zlib') //'libedit',
        ->disableDefaultLdflags()
        ->disablePkgName()
        ->disableDefaultPkgConfig()
        ->withSkipBuildLicense();

    $p->addLibrary($lib);
};
