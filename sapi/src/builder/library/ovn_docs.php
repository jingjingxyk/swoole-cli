<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $workdir = $p->getBuildDir();
    $ovs_prefix = OVS_PREFIX;
    $ovn_prefix = OVN_PREFIX;
    $lib = new Library('ovn_docs');
    $lib->withHomePage('https://github.com/ovn-org/ovn.git')
        ->withLicense('https://github.com/ovn-org/ovn/blob/main/LICENSE', Library::LICENSE_APACHE2)
        ->withManual('https://github.com/ovn-org/ovn/blob/main/Documentation/intro/install/general.rst')
        ->withFile('ovn-latest.tar.gz')
        ->withDownloadScript(
            'ovn',
            <<<EOF
            git clone -b main --depth=1 --progress https://github.com/ovn-org/ovn.git
EOF
        )
        ->withPrefix($ovn_prefix)
        ->withInstallCached(false)
        ->withPreInstallCommand(
            'alpine',
            <<<EOF
        apk add mandoc man-pages
        apk add ghostscript
        pip3 install sphinx virtualenv
EOF
        )
        ->withBuildScript(
            <<<EOF
        set -x

        virtualenv .venv
        source .venv/bin/activate
        pip3 install -r Documentation/requirements.txt

        sh ./boot.sh
        ./configure --help
        PACKAGES="openssl "
        CPPFLAGS="$(pkg-config  --cflags-only-I --static \$PACKAGES ) " \
        LDFLAGS="$(pkg-config   --libs-only-L   --static \$PACKAGES ) " \
        LIBS="$(pkg-config      --libs-only-l   --static \$PACKAGES ) " \
        ./configure  \
        --prefix={$ovn_prefix} \
        --enable-ssl \
        --enable-shared=no \
        --enable-static=yes \
        --with-ovs-source={$workdir}/ovs/ \
        --with-ovs-build={$workdir}/ovs/

        make dist-docs -j {$p->maxJob}
        make docs-check -j {$p->maxJob}

        deactivate

EOF
        )
        ->withDependentLibraries('openssl', 'ovs_docs');

    $p->addLibrary($lib);
};
