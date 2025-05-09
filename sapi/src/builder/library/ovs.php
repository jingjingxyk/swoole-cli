<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $ovs_prefix = OVS_PREFIX;
    $cflags = '';
    $ldflags = '';
    if ($p->isLinux()) {
        $cflags .= ' -static -fPIE ';
        $ldflags .= ' -static -static-pie ';
    }
    $lib = new Library('ovs');
    $lib->withHomePage('https://github.com/openvswitch/ovs/')
        ->withLicense('https://github.com/openvswitch/ovs/blob/master/LICENSE', Library::LICENSE_APACHE2)
        ->withManual('https://github.com/openvswitch/ovs/blob/main/Documentation/intro/install/general.rst')
        ->withAutoUpdateFile()
        ->withFile('ovs-latest.tar.gz')
        ->withDownloadScript(
            'ovs',
            <<<EOF
            git clone -b main --depth=1 --progress https://github.com/openvswitch/ovs.git
            # git clone -b v3.2.0 --depth=1 --progress https://github.com/openvswitch/ovs.git
EOF
        )
        ->withPrefix($ovs_prefix)
        ->withInstallCached(false)
        ->withBuildScript(
            <<<EOF

        ./boot.sh
        ./configure --help
        PACKAGES="openssl"
        CFLAGS=" {$cflags} " \
        CPPFLAGS="$(pkg-config  --cflags-only-I --static \$PACKAGES ) " \
        LDFLAGS="$(pkg-config   --libs-only-L   --static \$PACKAGES ) {$ldflags}" \
        LIBS="$(pkg-config      --libs-only-l   --static \$PACKAGES ) " \
        ./configure \
        --prefix={$ovs_prefix} \
        --enable-ssl \
        --enable-shared=no \
        --enable-static=yes
        make  -j {$p->maxJob}

        make install

EOF
        )
        ->withPkgName('libofproto')
        ->withPkgName('libopenvswitch')
        ->withPkgName('libovsdb')
        ->withPkgName('libsflow')
        ->withBinPath($ovs_prefix . '/bin/')
        ->withDependentLibraries('openssl') //'dpdk','unbound', 'libcap_ng'
    ;

    $p->addLibrary($lib);
};
