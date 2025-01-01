@echo off

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd /d %__PROJECT__%\var\windows-build-deps\php-src\
echo %cd%

if exist "Makefile" (
    nmake clean
)

:: buildconf.bat -f

echo "===================="

:: configure.bat --help



rem set "INCLUDE=%INCLUDE%;%__PROJECT__%\build\openssl\include\;%__PROJECT__%\build\zlib\include"
rem set "LIB=%LIB%;%__PROJECT__%\build\openssl\lib\;%__PROJECT__%\build\zlib\lib"
rem set "LIBPATH=%LIBPATH%;%__PROJECT__%\build\openssl\lib\;%__PROJECT__%\build\zlib\lib\"

:: echo %INCLUDE%
:: echo %LIB%
:: echo %LIBPATH%


set "CFLAGS=/EHsc /MT "
set "LDFLAGS=/VERBOSE:LIB	/NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrtd.lib /DEFAULTLIB:libcmt.lib "



rem set "LDFLAGS=/WHOLEARCHIVE /FORCE:MULTIPLE"

configure.bat ^
--with-php-build="c:\php-cli" ^
--with-extra-includes='' ^
--with-extra-libs='' ^
--with-toolset=vs ^
--disable-all         --disable-cgi      --enable-cli   ^
--enable-sockets      --enable-ctype     --enable-pdo    --enable-phar  ^
--enable-filter ^
--enable-xmlreader   --enable-xmlwriter ^
--enable-tokenizer

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
