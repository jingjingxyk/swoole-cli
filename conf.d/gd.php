<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $lib = new Library('libjpeg','/usr/libjpeg/');
    $lib->withUrl('https://codeload.github.com/libjpeg-turbo/libjpeg-turbo/tar.gz/refs/tags/2.1.2')
        ->withFile('libjpeg-turbo-2.1.2.tar.gz')
        ->withHomePage('https://libjpeg-turbo.org/')
        ->withLicense('https://github.com/libjpeg-turbo/libjpeg-turbo/blob/main/LICENSE.md', Library::LICENSE_BSD)
        ->withConfigure('cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/libjpeg .')
        ->withLdflags('-L/usr/libjpeg/lib64')
        ->withPkgConfig('/usr/libjpeg/lib64/pkgconfig')
        ->withPkgName('libjpeg libturbojpeg');

    if ($p->getOsType() === 'macos') {
        $lib->withLdflags('-L/usr/libjpeg/lib')
            ->withPkgConfig('/usr/libjpeg/lib/pkgconfig')
            ->withScriptAfterInstall('find ' . $lib->prefix . ' -name \*.dylib | xargs rm -f');
    }
    $p->addLibrary($lib);

    $p->addLibrary(
        (new Library('libwebp', '/usr/libwebp'))
            ->withUrl('https://codeload.github.com/webmproject/libwebp/tar.gz/refs/tags/v1.2.1')
            ->withConfigure('./autogen.sh && ./configure --prefix=/usr/libwebp --enable-static --disable-shared')
            ->withFile('libwebp-1.2.1.tar.gz')
            ->withHomePage('https://github.com/webmproject/libwebp')
            ->withLicense('https://github.com/webmproject/libwebp/blob/main/COPYING', Library::LICENSE_SPEC)
    );

    $p->addLibrary(
        (new Library('libpng', '/usr/libpng'))
            ->withUrl('https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz')
            ->withLicense('http://www.libpng.org/pub/png/src/libpng-LICENSE.txt', Library::LICENSE_SPEC)
            ->withConfigure('./configure --prefix=/usr/libpng --enable-static --disable-shared')
            ->withPkgName('libpng libpng16')
    );

    $p->addLibrary(
        (new Library('giflib'))
            ->withUrl('https://nchc.dl.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz')
            ->withLicense('http://giflib.sourceforge.net/intro.html', Library::LICENSE_SPEC)
            ->withCleanBuildDirectory()
            ->withScriptBeforeConfigure('

            default_prefix_dir="/ u s r" # 阻止 macos 系统下编译路径被替换
            # 替换空格
            default_prefix_dir=$(echo "$default_prefix_dir" | sed -e "s/[ ]//g")
            
            sed -i.bakup "s@PREFIX = $default_prefix_dir/local@PREFIX = /usr/giflib@" Makefile
       
       
            cat >> Makefile <<"EOF"
                        
install-lib-static:
	$(INSTALL) -d "$(DESTDIR)$(LIBDIR)"
	$(INSTALL) -m 644 libgif.a "$(DESTDIR)$(LIBDIR)/libgif.a"
EOF
                     
            ')
            ->withMakeOptions('libgif.a')
            //->withMakeOptions('all')
            ->withMakeInstallOptions('install-include && make  install-lib-static')
            # ->withMakeInstallOptions('install-include DESTDIR=/usr/giflib && make  install-lib-static DESTDIR=/usr/giflib')
            ->withLdflags('-L/usr/giflib/lib')
            ->disableDefaultPkgConfig()
    );

    $p->addLibrary(
        (new Library('freetype', '/usr/freetype'))
            ->withHomePage('https://freetype.org/')
            ->withUrl('https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.gz')
            ->withLicense('https://gitlab.freedesktop.org/freetype/freetype/-/blob/master/docs/FTL.TXT', Library::LICENSE_SPEC)
            ->withConfigure("
                export ZLIB_CFLAGS=$(pkg-config --cflags zlib) ;
                export ZLIB_LIBS=$(pkg-config --libs zlib) ;

                export BZIP2_CFLAGS='-I/usr/bzip2/include'
                export BZIP2_LIBS='-L/usr/bzip2/lib -lbz2'

                export LIBPNG_LIBS=$(pkg-config --cflags libpng libpng16) ;
                export LIBPNG_LIBS=$(pkg-config --libs libpng libpng16) ;
                
               ./configure --prefix=/usr/freetype --enable-static --disable-shared \
               --with-zlib=yes \
               --with-bzip2=yes \
               --with-png=yes \
               --with-harfbuzz=no \
               --with-brotli=no
            ")
            ->withLdflags('-L/usr/freetype/lib/')
            ->withPkgConfig('/usr/freetype/lib/pkgconfig')
            ->withPkgName('freetype2')

    );

    $p->addExtension((new Extension('gd'))
        ->withOptions('--enable-gd \
        --with-jpeg=/usr/libjpeg/ \
        --with-freetype=/usr/freetype \
        --with-webp=/usr/libwebp')
        ->withManual('https://www.php.net/manual/zh/image.installation.php')
        ->depends('libjpeg', 'freetype', 'libwebp', 'libpng', 'giflib')

    );
};
