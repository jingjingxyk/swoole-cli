@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

dumpbin /DEPENDENTS ".\var\windows-native\php-src\x64\Release_TS\php.exe"

cd /d %__PROJECT__%
endlocal


rem cmd /c var\native-build\php-sdk-binary-tools\phpsdk-starter.bat -c vs17 -a x64  -t sapi\scripts\windows-native\test.bat
