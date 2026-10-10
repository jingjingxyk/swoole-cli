@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

set "__PROJECT__=%cd%"
cd %__PROJECT__%

dumpbin /symbols .\var\native-build\php-src\x64\Release_TS\ext\swoole\ext-src\php_swoole.obj | findstr swoole_module_entry

dumpbin /DEPENDENTS ".\var\native-build\php-src\x64\Release_TS\php.exe"

cd /d %__PROJECT__%
endlocal

rem for /f "usebackq tokens=* delims=" %i in (`vswhere -products * -latest -prerelease -find **\VC\Auxiliary\Build\vcvarsall.bat`) do call "%i" x64
rem https://github.com/jingjingxyk/swoole-cli/releases/download/swoole-cli-v6.2.0.0/php.exe
rem curl.exe -fSLo php.exe https://github.com/jingjingxyk/swoole-cli/releases/download/swoole-cli-v6.2.0.0/php.exe

rem cmd /c var\native-build\php-sdk-binary-tools\phpsdk-starter.bat -c vs17 -a x64  -t sapi\scripts\windows-native\test.bat
