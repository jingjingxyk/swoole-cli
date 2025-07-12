<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $mpv_prefix = EXAMPLE_PREFIX;
    $tag = 'master';

    //构建参考
    // https://github.com/mpv-player/mpv-build

    $lib = new Library('mpv');
    $lib->withHomePage('https://mpv.io/')
        ->withLicense('http://www.gnu.org/licenses/lgpl-2.1.html', Library::LICENSE_LGPL)
        ->withManual('https://mpv.io/installation/')
        ->withManual('https://github.com/mpv-player/mpv')
        ->withManual('https://github.com/mpv-player/mpv-build')
        ->withManual('https://github.com/mpv-player/')
        ->withFile("mpv-${tag}.tar.gz")
        ->withDownloadScript(
            'mpv',
            <<<EOF
        git clone -b ${tag} https://github.com/mpv-player/mpv.git
EOF
        )
        ->withPreInstallCommand(
            'alpine',
            <<<EOF
            apk add ninja python3 py3-pip
            pip3 install mako
EOF
        )
        /** 使用 meson、ninja  构建 start **/
        ->withBuildScript(
            <<<EOF
            meson  -h
            meson setup -h
            # meson configure -h

            meson setup  build \
            -Dprefix={$mpv_prefix} \
            -Dbuildtype=release \
            -Ddefault_library=static \
            -Db_staticpic=true \
            -Db_pie=true \
            -Dprefer_static=true

            meson compile -C build
            meson install -C build

EOF
        )
        /** 使用 meson、ninja  构建 end **/

        ->withBinPath($mpv_prefix . '/bin/')
        ->withDependentLibraries('zlib', 'libexpat', 'libdrm');


    $p->addLibrary($lib);
};
