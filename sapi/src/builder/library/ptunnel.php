<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $example_prefix = EXAMPLE_PREFIX;

    $tag = 'master';
    $lib = new Library('ptunnel');
    $lib->withHomePage('https://www.kali.org/tools/ptunnel/')
        ->withLicense('https://salsa.debian.org/alteholz/ptunnel/-/blob/master/._LICENSE', Library::LICENSE_SPEC)
        ->withManual('https://salsa.debian.org/alteholz/ptunnel.git')
        ->withFile('ptunnel-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'ptunnel',
            <<<EOF
            git clone -b {$tag}  --depth=1 https://salsa.debian.org/alteholz/ptunnel.git
            # git clone -b {$tag}  --depth=1 https://github.com/esrrhs/pingtunnel.git
EOF
        )
        ->withPrefix($example_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)
        /* 使用 autoconfig automake  构建 start  */
        ->withConfigure(
            <<<EOF
        # sh autogen.sh

        # libtoolize -ci
        # autoreconf -fi
        # example:  libdc1394.php

        ./configure --help

        # LDFLAGS="\$LDFLAGS -static"

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES zlib"

        OPENSSL_CFLAGS=$(pkg-config  --cflags --static openssl)
        OPENSSL_LIBS=$(pkg-config    --libs   --static openssl)

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) " \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        ./configure \
        --prefix={$example_prefix} \
        --enable-shared=no \
        --enable-static=yes

        # 显示构建详情
        # make VERBOSE=1
        # 指定安装目录
        # make DESTDIR=/usr/local/swoole-cli/example
        #

EOF
        )
        ->withPkgName('libexample')
        ->withBinPath($example_prefix . '/bin/')
        ->withDependentLibraries('zlib', 'openssl');

    $p->addLibrary($lib);
};
