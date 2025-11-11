<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $brotli_prefix = BROTLI_PREFIX;
    $p->addLibrary(
        (new Library('brotli'))
            ->withHomePage('https://github.com/google/brotli')
            ->withManual('https://github.com/google/brotli')//有多种构建方式，选择cmake 构建
            ->withLicense('https://github.com/google/brotli/blob/master/LICENSE', Library::LICENSE_MIT)
            ->withUrl('https://github.com/google/brotli/archive/refs/tags/v1.0.9.tar.gz')
            ->withFileHash('md5', 'c2274f0c7af8470ad514637c35bcee7d')
            ->withFile('brotli-1.0.9.tar.gz')
            ->withPrefix($brotli_prefix)
            ->withBuildScript(
                <<<EOF
            mkdir -p build_dir
            cd build_dir
            # cmake -LH ..
            cmake .. \
            -DCMAKE_INSTALL_PREFIX={$brotli_prefix} \
            -DCMAKE_BUILD_TYPE=Release \
            -DBROTLI_SHARED_LIBS=ON \
            -DBROTLI_STATIC_LIBS=OFF \
            -DBROTLI_DISABLE_TESTS=OFF \
            -DBROTLI_BUNDLED_MODE=OFF \
            -DCMAKE_POLICY_VERSION_MINIMUM=3.5

            cmake --build . --config Release --target install
EOF
            )
            ->withScriptAfterInstall(
                <<<EOF
            rm -f {$brotli_prefix}/lib/libbrotlicommon-static.a
            rm -f {$brotli_prefix}/lib/libbrotlienc-static.a
            rm -f {$brotli_prefix}/lib/libbrotlidec-static.a
EOF
            )
            ->withPkgName('libbrotlicommon')
            ->withPkgName('libbrotlidec')
            ->withPkgName('libbrotlienc')
            ->withBinPath($brotli_prefix . '/bin/')
    );
};
