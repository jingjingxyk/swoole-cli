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
            -DBROTLI_SHARED_LIBS=OFF \
            -DBROTLI_STATIC_LIBS=ON \
            -DBROTLI_DISABLE_TESTS=OFF \
            -DBROTLI_BUNDLED_MODE=OFF

            # -DBROTLI_PARENT_DIRECTORY=ON

            cmake --build . --config Release --target install
EOF
            )
            ->withScriptAfterInstall(
                <<<EOF
            rm -rf {$brotli_prefix}/lib/*.so.*
            rm -rf {$brotli_prefix}/lib/*.so
            rm -rf {$brotli_prefix}/lib/*.dylib
            cp  -f {$brotli_prefix}/lib/libbrotlicommon-static.a {$brotli_prefix}/lib/libbrotli.a
            mv     {$brotli_prefix}/lib/libbrotlicommon-static.a {$brotli_prefix}/lib/libbrotlicommon.a
            mv     {$brotli_prefix}/lib/libbrotlienc-static.a    {$brotli_prefix}/lib/libbrotlienc.a
            mv     {$brotli_prefix}/lib/libbrotlidec-static.a    {$brotli_prefix}/lib/libbrotlidec.a
EOF
            )
            ->withPkgName('libbrotlicommon')
            ->withPkgName('libbrotlidec')
            ->withPkgName('libbrotlienc')
            ->withBinPath($brotli_prefix . '/bin/')
    );
    //$p->withVariable('CPPFLAGS', '$CPPFLAGS -I' . $brotli_prefix . '/include');
    //$p->withVariable('LDFLAGS', '$LDFLAGS -L' . $brotli_prefix . '/lib');
    //$p->withVariable('LIBS', '$LIBS -lbrotli  -lbrotlicommon -lbrotlienc  -lbrotlidec  ');
};
// libbrotlicommon.a 应该优先被链接
// 链接顺序问题
// Library order in static linking
// https://eli.thegreenplace.net/2013/07/09/library-order-in-static-linking
# 参考 https://bbs.huaweicloud.com/blogs/373470

//  -Wl,–whole-archive -Wl,–start-group a.o b.o c.o main.o -lf -ld -le -L./ -lc -Wl,–end-group -Wl,-no-whole-archive
