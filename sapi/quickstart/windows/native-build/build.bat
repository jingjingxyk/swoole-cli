@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd %__PROJECT__%\var\native-build\php-src\

rem set "INCLUDE=%INCLUDE%;%__PROJECT__%\openssl\include\;%__PROJECT__%\zlib\include"
rem set "LIB=%LIB%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib"
rem set "LIBPATH=%LIBPATH%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib\"

set CL=/MP
rem set RTLIBCFG=static
rem nmake   mode=static debug=false


nmake /E php.exe
exit /b
nmake /E /f Makefile  x-show-var
nmake /E /f Makefile  x-release-php



:: .\x64\Release\php.exe -v
:: .\x64\Release\php.exe -m
:: dumpbin /DEPENDENTS ".\x64\Release\php.exe"
:: dumpbin /DEPENDENTS ".\x64\Release_TS\php.exe"

cd %__PROJECT__%
endlocal

