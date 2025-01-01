@echo off

rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

.\var\windows-build-deps\php-sdk-binary-tools\phpsdk-vs17-x64.bat

cd /d %__PROJECT__%

