@echo off

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd /d %__PROJECT__%\var\native-build\php-src\
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
set "CFLAGS=/EHsc /MP /MT /UCRT  "
::  /MT
:: /showIncludes

rem https://learn.microsoft.com/zh-cn/cpp/c-runtime-library/crt-library-features?view=msvc-170

set "LDFLAGS=/VERBOSE:LIB	/DEFAULTLIB:libvcruntime.lib"
::set "LDFLAGS=/VERBOSE:LIB 	/NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib /NODEFAULTLIB:libcmtd.lib /DEFAULTLIB:libcmt.lib  /DEFAULTLIB:libucrt.lib /DEFAULTLIB:libcpmt.lib /DEFAULTLIB:libvcruntime.lib	/NODEFAULTLIB:libucrtd.lib  /NODEFAULTLIB:ucrt.lib /NODEFAULTLIB:ucrtd.lib	"

rem set "LDFLAGS=/WHOLEARCHIVE /FORCE:MULTIPLE"

rem https://github.com/php/php-src/blob/PHP-8.5.8/win32/winutil.c#L487
if not exist "win32\winutil.c.bak" (
    echo 文件不存在，正在创建...
    sed.exe -i".bak" "s/#if PHP_LINKER_MAJOR == 14/#if 0 && (PHP_LINKER_MAJOR == 14)/" win32\winutil.c
)

rem cat .\var\native-build\php-src\win32\winutil.c
rem cmd /c .\sapi\scripts\windows-native\clean.bat
rem .\var\native-build\php-src\x64\Release\php.exe -v

configure.bat ^
--with-php-build="c:\php-cli" ^
--with-extra-includes='' ^
--with-extra-libs='' ^
--with-toolset=vs ^
--with-mp=auto ^
--disable-all  ^
--disable-cgi  ^
--disable-zts  ^
--enable-cli   ^
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
:: --with-extra-includes="%INCLUDE%" ^
:: --with-extra-libs="%LIB%"


:: --enable-mbstring
:: --enable-redis ^
:: --enable-phar-native-ssl
:: --enable-fileinfo
:: --with-curl=static

cd /d %__PROJECT__%
endlocal
