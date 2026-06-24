@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd %__PROJECT__%\var\native-build\php-src\

rem set "INCLUDE=%INCLUDE%;%__PROJECT__%\openssl\include\;%__PROJECT__%\zlib\include"
rem set "LIB=%LIB%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib"
rem set "LIBPATH=%LIBPATH%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib\"

set CL=/MP
rem set RTLIBCFG=static
rem nmake   mode=static debug=false


:: nmake /E php.exe
:: exit /b
set "LIBS_CLI=kernel32.lib ole32.lib user32.lib advapi32.lib shell32.lib ws2_32.lib Dnsapi.lib psapi.lib bcrypt.lib"
set "LIBS_CLI=%LIBS_CLI% zlibstatic.lib"
rem LIBS_CLI="%LIBS_CLI%"

nmake /E /f Makefile  x-show-var
nmake /E /n /f Makefile  x-release-static-php mode=static



.\x64\Release_TS\php.exe -v
.\x64\Release_TS\php.exe -m
:: dumpbin /DEPENDENTS ".\x64\Release\php.exe"
dumpbin /DEPENDENTS ".\x64\Release_TS\php.exe"

cd %__PROJECT__%
endlocal

