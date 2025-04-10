<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $coturn_prefix = COTURN_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $libevent_prefix = LIBEVENT_PREFIX;
    $pgsql_prefix = PGSQL_PREFIX;
    $sqlite3_prefix = SQLITE3_PREFIX;
    $hiredis_prefix = HIREDIS_PREFIX;
    $libmongoc_prefix = LIBMONGOC_PREFIX;
    $libmicrohttpd_prefix = LIBMICROHTTPD_PREFIX;
    $snappy_prefix = SNAPPY_PREFIX;

    $cmake_options = "";
    if ($p->isLinux()) {
        $cmake_options .= '-DCMAKE_C_FLAGS=" -fPIE "';
        $cmake_options .= '-DCMAKE_C_LINKER_FLAGS=" -static -static-pie"';
        $cmake_options .= '-DCMAKE_STATIC_LINKER_FLAGS="-static"';
    }


    $cflags = $p->getOsType() == 'macos' ? ' ' : ' -static -fPIE -DOPENSSL_THREADS';
    $ldflags = $p->getOsType() == 'macos' ? ' ' : ' --static -static-pie';
    $libcpp = $p->getOsType() == 'macos' ? '-lc++' : ' -lstdc++ ';


    $dependentLibraries = [
        'libevent',
        'openssl',
        'sqlite3',
        'hiredis',
        'pgsql',
        'libmongoc',
       // 'liboauth2'
    ];
    $pkg_options = '';
    if ($p->isLinux()) {
        $pkg_options .= 'libsctp';
        $dependentLibraries[] = 'libsctp';
    }

    $tag = 'master';
    $tag = '4.6.3';
    $p->addLibrary(
        (new Library('coturn'))
            ->withHomePage('https://github.com/coturn/coturn/')
            ->withManual('https://github.com/coturn/coturn/tree/master/docs')
            ->withDocumentation('https://quay.io/repository/coturn/coturn')
            ->withLicense('https://github.com/coturn/coturn/blob/master/LICENSE', Library::LICENSE_SPEC)
            ->withFile('coturn-' . $tag . '.tar.gz')
            ->withDownloadScript(
                'coturn',
                <<<EOF
                git clone -b {$tag} --depth=1 https://github.com/coturn/coturn.git
EOF
            )
            ->withPrefix($coturn_prefix)
            ->withBuildCached(false)
            ->withInstallCached(false)
            /*
            ->withBuildScript(
                <<<EOF
           mkdir -p build
           cd build
           # cmake -LH ..
           cmake .. \
           -DCMAKE_INSTALL_PREFIX={$coturn_prefix} \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_C_STANDARD=11 \
           -DCMAKE_C_FLAGS="-DOPENSSL_THREADS=1 -DTURN_NO_PROMETHEUS -DTURN_NO_SYSTEMD -DTURN_NO_MYSQL -DTURN_NO_SCTP -DTURN_NO_PostgreSQL" \
           -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
           -DCMAKE_VERBOSE_MAKEFILE=ON \
           -DBUILD_SHARED_LIBS=OFF \
           -DBUILD_STATIC_LIBS=ON \
           -DOPENSSL_USE_STATIC_LIBS=ON \
           -DFUZZER=OFF \
           -DWITH_MYSQL=OFF \
           -Dhiredis_DIR={$hiredis_prefix} \
           -Dmongo_DIR={$libmongoc_prefix} \
           -DCMAKE_PREFIX_PATH="{$openssl_prefix};{$libevent_prefix};{$sqlite3_prefix};" \
           -DCMAKE_DISABLE_FIND_PACKAGE_libsystemd=ON \
           -DCMAKE_DISABLE_FIND_PACKAGE_Prometheus=ON \
           {$cmake_options}

            cmake --build . --config Release
            cmake --build . --config Release --target install

            # -DCMAKE_C_LINKER_FLAGS=" -lpq -lpgport -lpgcommon " \
            # {$pgsql_prefix};
EOF
            )
            */
            ->withConfigure(
                <<<EOF
            set -x
            export TURN_NO_PROMETHEUS=ON
            export TURN_NO_GCM=ON
            export TURN_NO_SYSTEMD=ON
            export TURN_NO_MYSQL=ON

            # export TURN_NO_MONGO=OFF
            # export TURN_NO_SQLITE=OFF
            # export TURN_NO_PQ=OFF
            # export TURN_NO_HIREDIS=OFF
            # export TURN_NO_SCTP=OFF
            # TURN_SCTP_INCLUDE

            export TURN_IP_RECVERR=ON

            PACKAGES='sqlite3'
            PACKAGES="\$PACKAGES libevent  libevent_core libevent_extra  libevent_openssl  libevent_pthreads"
            PACKAGES="\$PACKAGES libpq"
            PACKAGES="\$PACKAGES hiredis"
            PACKAGES="\$PACKAGES {$pkg_options}"
            PACKAGES="\$PACKAGES  libbson-static-1.0 libmongoc-static-1.0 "
            # PACKAGES="\$PACKAGES  liboauth2 "

            export SSL_CFLAGS=$(pkg-config    --cflags --static openssl)
            export SSL_LIBS=$(pkg-config      --libs   --static openssl)

            export CPPFLAGS="$(pkg-config  --cflags-only-I --static  \$PACKAGES)  "
            export LDFLAGS="$(pkg-config   --libs-only-L   --static  \$PACKAGES)  {$ldflags} " # -Wl,--whole-archive -l:pgcommon.a -l:pgport.a -l:pq.a -Wl,--no-whole-archive
            export LIBS="$(pkg-config      --libs-only-l   --static  \$PACKAGES)  {$libcpp} "
            export CFLAGS="  -g  -std=gnu11   {$cflags}  "

            export DBCFLAGS="$(pkg-config  --cflags --static libpq sqlite3 hiredis libbson-static-1.0 libmongoc-static-1.0  )"
            export DBLIBS="$(pkg-config     --libs  --static libpq sqlite3 hiredis libbson-static-1.0 libmongoc-static-1.0  ) {$libcpp}"

            export OSLIBS=\$LIBS
            export OSCFLAGS=\$CPPFLAGS
            export PTHREAD_LIBS='-pthread'


            sed -i.'backup' 's/libmongoc-1.0/libmongoc-static-1.0/' ./configure

            ./configure --help
            ./configure  \
            --prefix=$coturn_prefix

EOF
            )
            ->withBinPath($coturn_prefix . '/bin/')
            ->withDependentLibraries(
                ...$dependentLibraries
            )
    );
};

/*
 *  nm /usr/local/swoole-cli/pgsql/lib/libpq.a | grep PQconnectStart
 *  nm -u /usr/local/swoole-cli/pgsql/lib/libpq.a
 *
 *   Linux - nm命令
 *
 *   https://blog.csdn.net/guoqx/article/details/127828038
 *
 *   如果是小写字符，则是本地符号(local)，如果是大写，则是外部符号(external)
 */
