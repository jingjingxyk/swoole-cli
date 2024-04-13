<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $mpdecimal_prefix = MPDECIMAL_PREFIX;
    $mpdecimal_prefix = MPDECIMAL_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    //文件名称 和 库名称一致
    $lib = new Library('mpdecimal');
    $lib->withHomePage('https://www.bytereef.org/mpdecimal/')
        ->withLicense('https://www.bytereef.org/mpdecimal/download.html', Library::LICENSE_BSD)
        ->withManual('https://www.bytereef.org/mpdecimal/quickstart.html')

        ->withUrl('https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.0.tar.gz')
        ->withPrefix($mpdecimal_prefix)

        ->withConfigure(
            <<<EOF
        ./configure --help

        # LDFLAGS="\$LDFLAGS -static"

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES zlib"

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) " \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        ./configure \
        --prefix={$mpdecimal_prefix} \
        --enable-shared=no \
        --enable-static=yes
EOF
        )

        ->withPkgName('example')
        ->withBinPath($mpdecimal_prefix . '/bin/')
        //依赖其它静态链接库
        ->withDependentLibraries('zlib', 'openssl')
    ;

    $p->addLibrary($lib);
};
