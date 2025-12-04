@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

rem var\windows-build-deps\php-sdk-binary-tools\phpsdk-starter.bat -c vs17 -a x64  -t sapi\quickstart\windows\native-build\run.bat
rem D:\a\swoole-cli\swoole-cli\var\windows-build-deps\php-src\x64\Release_TS

for /f "tokens=1,2 delims==" %%I in ('set') do (
    echo %%I = %%J
)
call %__PROJECT__%\sapi\quickstart\windows\native-build\config.bat
call %__PROJECT__%\sapi\quickstart\windows\native-build\x_custom_config.bat
call %__PROJECT__%\sapi\quickstart\windows\native-build\build.bat


cd /d %__PROJECT__%
endlocal
