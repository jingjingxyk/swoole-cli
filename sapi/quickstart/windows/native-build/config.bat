@echo off

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd /d %__PROJECT__%\var\windows-build-deps\php-src\
set "PHP_SRC=%cd%"
echo %cd%

if exist "configure.js" (
    nmake clean
)

call buildconf.bat -f

echo "========HELP============"

call configure.bat --help


echo "===================="

rem set "INCLUDE=%INCLUDE%;%__PROJECT__%\build\openssl\include\;%__PROJECT__%\build\zlib\include"
rem set "LIB=%LIB%;%__PROJECT__%\build\openssl\lib\;%__PROJECT__%\build\zlib\lib"
rem set "LIBPATH=%LIBPATH%;%__PROJECT__%\build\openssl\lib\;%__PROJECT__%\build\zlib\lib\"

:: echo %INCLUDE%
:: echo %LIB%
:: echo %LIBPATH%

:: set "INCLUDE=%INCLUDE%;%PHP_SRC%\ext\"
set "CFLAGS=/EHsc /MT /UCRT  /showIncludes /link /verbose "

rem https://learn.microsoft.com/zh-cn/cpp/c-runtime-library/crt-library-features?view=msvc-170
rem https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features?view=msvc-170

::set "LDFLAGS=/VERBOSE:LIB	/NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrtd.lib /DEFAULTLIB:libcmt.lib  /DEFAULTLIB:libucrt.lib /DEFAULTLIB:libvcruntime.lib	/NODEFAULTLIB:libucrtd.lib  /NODEFAULTLIB:ucrt.lib /NODEFAULTLIB:ucrtd.lib	"
set "LDFLAGS=/VERBOSE:LIB /dump /imports	/NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrtd.lib /NODEFAULTLIB:libcmt.lib  /DEFAULTLIB:libucrt.lib /DEFAULTLIB:libcpmt.lib /DEFAULTLIB:libvcruntime.lib	/NODEFAULTLIB:libucrtd.lib  /NODEFAULTLIB:ucrt.lib /NODEFAULTLIB:ucrtd.lib	"




rem set "LDFLAGS=/WHOLEARCHIVE /FORCE:MULTIPLE"

configure.bat ^
--with-php-build="c:\php-cli" ^
--with-extra-includes='' ^
--with-extra-libs='' ^
--with-toolset=vs ^
--with-mp=auto ^
--disable-all         --disable-cgi      --enable-cli   ^
--enable-sockets      --enable-ctype     --enable-pdo    --enable-phar  ^
--enable-filter ^
--enable-xmlreader   --enable-xmlwriter ^
--enable-tokenizer

:: --enable-cli-win32 ^
:: --disable-zts ^
:: --enable-apcu ^
:: --enable-bcmath ^
:: --enable-zlib  ^
:: --with-openssl=static ^
:: --with-toolset=vs ^
:: --with-extra-includes="%INCLUDE%" ^
:: --with-extra-libs="%LIB%"


:: --enable-mbstring
:: --enable-redis ^
:: --enable-phar-native-ssl
:: --enable-fileinfo
:: --with-curl=static

cd /d %__PROJECT__%
endlocal
