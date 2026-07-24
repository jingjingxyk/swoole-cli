@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd %__PROJECT__%\var\native-build\php-src\

set CL=/MP

rem set RTLIBCFG=static
rem nmake   mode=static debug=false


:: nmake /E php.exe
:: exit /b
rem set "LIBS_CLI=kernel32.lib ole32.lib user32.lib advapi32.lib shell32.lib ws2_32.lib Dnsapi.lib psapi.lib bcrypt.lib"
rem set "LIBS_CLI=%LIBS_CLI% zlibstatic.lib"

set "X_LIBS= libzstd_a.lib "


nmake /E /f Makefile  x-show-var
nmake /E /f Makefile  x-release-static-php
:: nmake /E /n /f Makefile  x-release-static-php mode=static LIBS_CLI="%LIBS_CLI%"

rem debug
:: set "PATH=%PATH%;C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\"
:: $env:Path += ";C:\Program Files (x86)\Windows Kits\10\Debuggers\x64"
:: cdb.exe -pn  "%__PROJECT__%\var\native-build\php-src\x64\Release_TS\php.exe"

.\x64\Release_TS\php.exe -v
.\x64\Release_TS\php.exe -m
:: dumpbin /DEPENDENTS ".\x64\Release\php.exe"

dumpbin /DEPENDENTS ".\x64\Release_TS\php.exe"

cd %__PROJECT__%
endlocal

