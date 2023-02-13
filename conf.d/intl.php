<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $p->addLibrary(
        (new Library('icu'))
            ->withUrl('https://github.com/unicode-org/icu/releases/download/release-60-3/icu4c-60_3-src.tgz')
            ->withHomePage('https://icu.unicode.org/')
            ->withLicense('https://github.com/unicode-org/icu/blob/main/icu4c/LICENSE', Library::LICENSE_SPEC)
            ->withManual("https://unicode-org.github.io/icu/userguide/icu4c/build.html")
            ->withCleanBuildDirectory()
            ->withConfigure('
             source/runConfigureICU Linux --help

             CPPFLAGS="-DU_CHARSET_IS_UTF8=1  -DU_USING_ICU_NAMESPACE=1  -DU_STATIC_IMPLEMENTATION=1"

             source/runConfigureICU Linux --prefix=/usr/icu \
             --enable-icu-config=no \
             --enable-static=yes \
             --enable-shared=no \
             --with-data-packaging=archive \
             --enable-release=yes \
             --enable-extras=yes \
             --enable-icuio=yes \
             --enable-dyload=no \
             --enable-tools=yes \
             --enable-tests=no \
             --enable-samples=no
             ')
            ->withMakeOptions('all VERBOSE=1')
            ->withPkgName('icu-uc icu-io icu-i18n')
            ->withPkgConfig('/usr/icu/lib/pkgconfig')
            ->withLdflags('-L/usr/icu/lib')
    );
    $p->addExtension((new Extension('intl'))->withOptions('--enable-intl')->depends('icu'));
};
