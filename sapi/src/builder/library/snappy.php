<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $snappy_prefix = SNAPPY_PREFIX;
    $p->addLibrary(
        (new Library('snappy'))
            ->withHomePage('https://github.com/google/snappy')
            ->withManual('https://github.com/google/snappy/blob/main/README.md')
            ->withLicense('https://github.com/google/snappy/blob/main/COPYING', Library::LICENSE_BSD)
            //->withUrl('https://github.com/google/snappy/archive/refs/tags/1.1.10.tar.gz')
            //->withFile('snappy-1.1.10.tar.gz')
            ->withFile('snappy-latest.tar.gz')
            ->withDownloadScript(
                'snappy',
                <<<EOF
                # 等待这个问题 https://github.com/google/snappy/commit/27f34a580be4a3becf5f8c0cba13433f53c21337
                # 发版，以后就可以指定版本了
                git clone -b main https://github.com/google/snappy.git
EOF
            )
            ->withPrefix($snappy_prefix)
            ->withConfigure(
                <<<EOF
                mkdir -p build
                cd build
                cmake .. \
                -Wsign-compare \
                -DCMAKE_INSTALL_PREFIX={$snappy_prefix} \
                -DCMAKE_INSTALL_LIBDIR={$snappy_prefix}/lib \
                -DCMAKE_INSTALL_INCLUDEDIR={$snappy_prefix}/include \
                -DCMAKE_BUILD_TYPE=Release  \
                -DBUILD_SHARED_LIBS=OFF  \
                -DBUILD_STATIC_LIBS=ON \
                -DSNAPPY_BUILD_TESTS=OFF \
                -DSNAPPY_BUILD_BENCHMARKS=OFF
EOF
            )
            ->withBinPath($snappy_prefix . '/bin/')
    );
    $p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . SNAPPY_PREFIX . '/include');
    $p->withVariable('LDFLAGS', '$LDFLAGS -L' . SNAPPY_PREFIX . '/lib');
    $p->withVariable('LIBS', '$LIBS -liconv');
};
