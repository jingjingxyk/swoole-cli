<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $ovs_prefix = OVS_PREFIX;
    $packages = '';
    if ($p->isMacos()) {
        throw new \Exception('ovs docs only linux !');
    }
    $lib = new Library('ovs_docs');
    $lib->withHomePage('https://github.com/openvswitch/ovs/')
        ->withLicense('https://github.com/openvswitch/ovs/blob/master/LICENSE', Library::LICENSE_APACHE2)
        ->withManual('https://github.com/openvswitch/ovs/blob/v3.1.1/Documentation/intro/install/general.rst')
        ->withFile('ovs-latest.tar.gz')
        ->withDownloadScript(
            'ovs',
            <<<EOF
            git clone -b main --depth=1 --progress https://github.com/openvswitch/ovs.git
EOF
        )
        ->withPrefix($ovs_prefix)
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

        ./boot.sh
        ./configure --help
        PACKAGES="openssl {$packages}"
        CPPFLAGS="$(pkg-config  --cflags-only-I --static \$PACKAGES ) " \
        LDFLAGS="$(pkg-config   --libs-only-L   --static \$PACKAGES ) " \
        LIBS="$(pkg-config      --libs-only-l   --static \$PACKAGES ) " \
        ./configure \
        --prefix={$ovs_prefix} \
        --enable-ssl \
        --enable-shared=no \
        --enable-static=yes

        # 文档构建
        # https://github.com/openvswitch/ovs/blob/master/Documentation/intro/install/documentation.rst

        make docs-check -j {$p->maxJob}

        deactivate

EOF
        )
        ->withDependentLibraries('openssl');

    $p->addLibrary($lib);
};
