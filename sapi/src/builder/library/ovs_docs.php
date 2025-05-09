<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $ovs_prefix = OVS_PREFIX;
    $packages = '';
    if ($p->isLinux()) {
        // $packages .= ' libcap-ng ';
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
        pip3 install pipenv
        pip3 install sphinx virtualenv

        # apk add bind-tools  # dig pypi.org

        # sysctl -w net.ipv6.conf.all.disable_ipv6=1
        # sysctl -w net.ipv6.conf.default.disable_ipv6=1
EOF
        )
        ->withBuildScript(
            <<<EOF
        set -x


        virtualenv .venv
        source .venv/bin/activate
        pip3 install -r Documentation/requirements.txt
        # pip3 install jinja2==3.0.0
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

        # 文档构建  https://github.com/openvswitch/ovs/blob/master/Documentation/intro/install/documentation.rst

        make docs-check -j {$p->maxJob}

        deactivate



        # make install

        # export PIPENV_PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple
        # cd Documentation/
        # pipenv --rm
        # pipenv --python 3
        # pipenv shell

        # 参考 文档 https://pipenv-fork.readthedocs.io/en/latest/advanced.html
        # pipenv install -r requirements.txt -i https://pypi.python.org/simple
        # pipenv install -r requirements.txt --pypi-mirror https://pypi.tuna.tsinghua.edu.cn/simple
        # pipenv install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
        # pipenv run pip3 install -r requirements.txt

        # pipenv install jinja2==3.0.0
        # pipenv run python3 conf.py




EOF
        )
        ->withDependentLibraries('openssl');

    $p->addLibrary($lib);
};
