<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $taos_tools_prefix = TAOS_TOOLS_PREFIX;
    $jansson_prefix = JANSSON_PREFIX;
    $zlib_prefix = ZLIB_PREFIX;
    $liblzma_prefix = LIBLZMA_PREFIX;
    $snappy_prefix = SNAPPY_PREFIX;
    $p->addLibrary(
        (new Library('taos_tools'))
            ->withHomePage('https://github.com/taosdata/taos-tools.git')
            ->withLicense('https://github.com/taosdata/taos-tools/blob/main/LICENSE', Library::LICENSE_MIT)
            ->withManual('https://github.com/taosdata/taos-tools.git')
            ->withPrefix($taos_tools_prefix)
            ->withFile('taos_tools_v3.0.tar.gz')
            ->withDownloadScript(
                'taos-tools',
                <<<EOF
                git clone -b 3.0 https://github.com/taosdata/taos-tools.git
EOF
            )
            ->withConfigure(
                <<<EOF
                mkdir -p build
                cd build
                cmake .. \
                -DCMAKE_INSTALL_PREFIX={$taos_tools_prefix} \
                -DCMAKE_BUILD_TYPE=Release  \
                -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
                -DBUILD_SHARED_LIBS=OFF \
                -DBUILD_STATIC_LIBS=ON \
                -DJANSSON_ROOT={$jansson_prefix} \
                -DZLIB_ROOT={$zlib_prefix} \
                -DLZMA_ROOT={$liblzma_prefix} \
                -DSNAPPY_ROOT={$snappy_prefix} \
                -DZLIB_LIBRARY={$zlib_prefix}/lib/libz.a \
                -DZLIB_INCLUDE_DIR={$zlib_prefix}/include/ \
                -DSNAPPY_LIBRARY={$snappy_prefix}/lib/libsnappy.a \
                -DSNAPPY_INCLUDE_DIR={$snappy_prefix}/include/ \
                -DCUNIT_DISABLE_EXAMPLES=ON \
                -DCUNIT_DISABLE_TESTS=ON
                # -DCMAKE_DISABLE_FIND_PACKAGE_snappy=ON \
                # -DCMAKE_DISABLE_FIND_PACKAGE_zlib=ON



EOF
            )
            ->withDependentLibraries('snappy', 'zlib', 'liblzma', 'jansson', 'cjson')
    );
};
