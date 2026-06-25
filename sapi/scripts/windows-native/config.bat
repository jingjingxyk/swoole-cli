@echo off

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

rem cd d:\a\swoole-cli\swoole-cli\
rem call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
env

where bison
bison --version


set "__PROJECT__=%cd%"
echo %cd%
cd /d %__PROJECT__%\var\native-build\php-src\
set "PHP_SRC=%cd%"
echo %cd%

set "INCLUDES=%__PROJECT__%\build\zlib\include"
set "LIBS=%__PROJECT__%\build\zlib\lib"



:: set "INCLUDE=%INCLUDE%;%PHP_SRC%\ext\"
set "INCLUDE=%INCLUDE%;%INCLUDES%"
set "LIB=%LIB%;%LIBS%"
dir "%LIB%" | findstr ws2_32.lib
:: echo %LIBPATH%

if exist "configure.js" (
    nmake clean
)

call buildconf.bat -f

echo "========HELP============"

call configure.bat --help


echo "===================="


set "CFLAGS=/EHsc /MP /MT /UCRT"
:: /MT
:: /showIncludes

rem https://learn.microsoft.com/zh-cn/cpp/c-runtime-library/crt-library-features?view=msvc-170

set "LDFLAGS=/VERBOSE:LIB	/DEFAULTLIB:libvcruntime.lib /DEFAULTLIB:libucrt.lib "
:: set "LDFLAGS=%LDFLAGS% kernel32.lib ole32.lib user32.lib advapi32.lib shell32.lib ws2_32.lib Dnsapi.lib psapi.lib bcrypt.lib"
:: set "LDFLAGS=%LDFLAGS% zlib.lib"

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

mkdir %__PROJECT__%\build

bison.exe -Wall --output=Zend/zend_language_parser.c -v -d Zend/zend_language_parser.y

configure.bat ^
--with-php-build="%__PROJECT__%\build" ^
--with-extra-includes="%INCLUDE%" ^
--with-extra-libs="%LIB%" ^
--with-toolset=vs ^
--with-mp=auto ^
--disable-all  ^
--disable-cgi  ^
--enable-cli   ^
--enable-zts ^
--enable-sockets      --enable-ctype     --enable-pdo    --enable-phar  ^
--enable-filter ^
--enable-xmlreader   --enable-xmlwriter ^
--enable-tokenizer ^
--enable-sockets ^
--enable-bcmath ^
--enable-zlib

:: --enable-cli-win32 ^
:: --disable-zts ^
:: --enable-apcu ^
:: --enable-bcmath ^
:: --enable-zlib  ^
:: --with-openssl=static ^
:: --with-extra-includes="%INCLUDE%" ^
:: --with-extra-libs="%LIB%"
:: --disable-zts
:: --with-php-build="c:\php-cli" ^
:: --enable-mbstring
:: --enable-redis ^
:: --enable-phar-native-ssl
:: --enable-fileinfo
:: --with-curl=static

cd /d %__PROJECT__%
endlocal
