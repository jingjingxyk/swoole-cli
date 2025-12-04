@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd %__PROJECT__%\var\windows-build-deps\php-src\

where sed.exe

dir  %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\msys2\usr\bin\



:: vswhere.exe -products* -requires
:: vswhere.exe -legacy -prerelease -format json
:: vswhere.exe -legacy -prerelease -format json | jq

:: vswhere.exe -legacy -prerelease

cd %__PROJECT__%
endlocal

