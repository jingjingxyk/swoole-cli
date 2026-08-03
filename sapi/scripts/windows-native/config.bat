@echo off

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

rem cd d:\a\swoole-cli\swoole-cli\
vswhere -products * -latest -prerelease -find **\VC\Auxiliary\Build\vcvarsall.bat
rem call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
env

where bison
bison --version
re2c --version

set "__PROJECT__=%cd%"
echo %cd%
cd /d %__PROJECT__%\var\native-build\php-src\
set "PHP_SRC=%cd%"
echo %cd%

if exist "configure.js" (
    nmake clean
)

set "X_INCLUDES="
set "X_LIBS="

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\zlib\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\zlib\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\openssl\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\openssl\lib"

rem set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\icu\include"
rem set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\icu\lib"

rem set "X_INCLUDES=%X_INCLUDES%;D:\a\swoole-cli\swoole-cli\var\native-build\vcpkg\packages\libiconv_x64-windows-static\include"
rem set "X_LIBS=%X_LIBS%;D:\a\swoole-cli\swoole-cli\var\native-build\vcpkg\packages\libiconv_x64-windows-static\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\liblz4\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\liblz4\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\bzip2\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\bzip2\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\liblzma\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\liblzma\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\brotli\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\brotli\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libzstd\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libzstd\lib"


set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libzip\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libzip\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libiconv\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libiconv\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libpsl\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libpsl\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\cares\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\cares\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libssh2\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libssh2\lib"

:: set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libidn2\include"
:: set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libidn2\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libnghttp2\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libnghttp2\lib"


set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\libnghttp3\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\libnghttp3\lib"


set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\ngtcp2\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\ngtcp2\lib"

:: set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\curl\include"
:: set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\curl\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\oniguruma\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\oniguruma\lib"

set "X_INCLUDES=%X_INCLUDES%;%__PROJECT__%\build\include"
set "X_LIBS=%X_LIBS%;%__PROJECT__%\build\lib"


:: set "INCLUDE=%INCLUDE%;%PHP_SRC%\ext"
set "INCLUDE=%X_INCLUDES%;%INCLUDE%"
set "LIB=%X_LIBS%;%LIB%"
set "X_CUSTOM_LIBS="
set "X_CUSTOM_LIBS= %X_CUSTOM_LIBS% libzstd_a.lib"
set "X_CUSTOM_LIBS= %X_CUSTOM_LIBS% cares.lib psl.lib ngtcp2.lib ngtcp2_crypto_ossl.lib nghttp3.lib "

echo "INCLUDE=%INCLUDE%"
echo "LIB=%LIB%"

set "PHP_PHP_BUILD=%__PROJECT__%\build"
echo %PHP_PHP_BUILD%
mkdir %PHP_PHP_BUILD%

call buildconf.bat -f

echo "========HELP============"

call configure.bat --help


:: sed.exe -i.".bak" '/var dir_part_to_add = "";/i  STDOUT.WriteLine(header_name);' configure.js
:: sed.exe -i.".bak" '/var dir_part_to_add = "";/i  STDOUT.WriteLine(flag_name);' configure.js
:: sed.exe -i.".bak" '/var dir_part_to_add = "";/i  STDOUT.WriteLine(path_to_check);' configure.js
:: sed.exe -i.".bak" '/var dir_part_to_add = "";/i  STDOUT.WriteLine(use_env);' configure.js
:: sed.exe -i.".bak" '/var dir_part_to_add = "";/i  STDOUT.WriteLine(add_dir_part);' configure.js
:: sed.exe -i.".bak" '/var dir_part_to_add = "";/i  STDOUT.WriteLine(add_to_flag_only);' configure.js


:: sed.exe -i.".bak" '/dep_present = eval("PHP_" + DEP);/i  STDOUT.WriteLine(extname);' configure.js
:: sed.exe -i.".bak" '/dep_present = eval("PHP_" + DEP);/i  STDOUT.WriteLine(dependson);' configure.js
:: sed.exe -i.".bak" '/dep_present = eval("PHP_" + DEP);/i  STDOUT.WriteLine(optional);' configure.js

:: sed.exe -i.".bak" '/if (absolute_path.indexOf(PHP_PHP_BUILD) == 0) {/i  STDOUT.WriteLine(path);' configure.js
:: sed.exe -i.".bak" '/if (absolute_path.indexOf(PHP_PHP_BUILD) == 0) {/i  STDOUT.WriteLine(absolute_path);' configure.js


sed.exe -i.".bak" '/var i, j, k, libname;/i STDOUT.WriteLine(libnames);' configure.js
sed.exe -i.".bak" '/var i, j, k, libname;/i STDOUT.WriteLine(target);' configure.js
sed.exe -i.".bak" '/var i, j, k, libname;/i STDOUT.WriteLine(path_to_check);' configure.js
sed.exe -i.".bak" '/var i, j, k, libname;/i STDOUT.WriteLine(common_name);' configure.js

sed.exe -i.".bak" '/generate_files();/i STDOUT.WriteLine("=======================");' configure.js
sed.exe -i.".bak" '/generate_files();/i STDOUT.WriteLine(PHP_PHP_BUILD);' configure.js

sed.exe -i.".bak" "s/php_libmagic.c', true/php_libmagic.c', null/" ext/fileinfo/config.w32
sed.exe -i.".bak" '15 a\ADD_FLAG("CFLAGS_FILEINFO", "/D FILEINFO_STATIC ");' ext/fileinfo/config.w32



echo "===================="


set "CFLAGS=/EHsc /MP /MT /UCRT"

:: /showIncludes
:: /MANIFEST /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /manifest:embed

rem https://learn.microsoft.com/zh-cn/cpp/c-runtime-library/crt-library-features?view=msvc-170

set "LDFLAGS=/VERBOSE:LIB	/DEFAULTLIB:libvcruntime.lib /DEFAULTLIB:libucrt.lib /NODEFAULTLIB:MSVCRT"
:: set "LDFLAGS=%LDFLAGS% kernel32.lib ole32.lib user32.lib advapi32.lib shell32.lib ws2_32.lib Dnsapi.lib psapi.lib bcrypt.lib"

:: dir "%LIBS%" | findstr ws2_32.lib
:: echo %LIBPATH%

::set "LDFLAGS=/VERBOSE:LIB 	/NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib /NODEFAULTLIB:libcmtd.lib /DEFAULTLIB:libcmt.lib  /DEFAULTLIB:libucrt.lib /DEFAULTLIB:libcpmt.lib /DEFAULTLIB:libvcruntime.lib	/NODEFAULTLIB:libucrtd.lib  /NODEFAULTLIB:ucrt.lib /NODEFAULTLIB:ucrtd.lib	"


rem no link vcruntime140d.dll
rem https://github.com/php/php-src/blob/PHP-8.5.8/win32/winutil.c#L487
if not exist "win32\winutil.c.bak" (
    echo "win32\winutil.c.bak no found , now creating it ..."
    sed.exe -i".bak" "s/#if PHP_LINKER_MAJOR == 14/#if 0/" win32\winutil.c
)


rem cat .\var\native-build\php-src\win32\winutil.c
rem cat .\var\native-build\php-src\win32\winutil.c.bak
rem cat .\var\native-build\php-src\sapi/cli/php_cli.c
rem cmd /c .\sapi\scripts\windows-native\clean.bat
rem cmd /c sapi\scripts\windows-native\entry.bat
rem cmd /c var\native-build\php-sdk-binary-tools\phpsdk-starter.bat -c vs17 -a x64  -t .\sapi\scripts\windows-native\clean.bat
rem .\var\native-build\php-src\x64\Release\php.exe -v
rem .\var\native-build\php-src\x64\Release_TS\php.exe -v

set "CFLAGS=%CFLAGS% -D isatty=_isatty"

sed.exe -i.".bak" 's/ZEND_DLIMPORT/ /' Zend\zend_stream.c
rem _tsrm_ls_cache redefined
sed.exe -i.".bak" 's/ZEND_TSRMLS_CACHE_DEFINE()/ /' sapi/cli/php_cli.c

sed.exe -i.".bak" 's/#ifdef HAVE_LIBXML/#ifdef HAVE_LIBXML_X/' win32/dllmain.c

bison.exe -Wall --output=Zend/zend_language_parser.c -v -d Zend/zend_language_parser.y


set CL=/MP


configure.bat ^
--with-php-build="%PHP_PHP_BUILD%" ^
--with-extra-includes="%INCLUDE%" ^
--with-extra-libs="%LIB%" ^
--with-toolset=vs ^
--with-mp=auto ^
--disable-all  ^
--disable-cgi  ^
--enable-cli   ^
--enable-zts ^
--enable-filter ^
--enable-session ^
--enable-tokenizer ^
--enable-ctype    ^
--enable-pdo  ^
--enable-phar  ^
--enable-phar-native-ssl ^
--enable-sockets ^
--enable-bcmath ^
--enable-zlib ^
--with-openssl=static ^
--with-bz2 ^
--enable-zip ^
--with-iconv=static ^
--with-libxml ^
--with-xml ^
--enable-xmlreader ^
--enable-xmlwriter ^
--with-dom ^
--with-simplexml ^
--with-curl ^
--enable-fileinfo ^
--enable-mbstring ^
--enable-mbregex


:: --enable-intl
:: --with-readline ^
:: --with-gd ^
:: --with-libwebp ^
:: --with-libavif
:: --enable-exif ^
:: --enable-soap ^
:: --with-xsl

:: --enable-cli-win32 ^
:: --disable-zts ^
:: --enable-apcu ^
:: --enable-redis ^

cd /d %__PROJECT__%
endlocal
