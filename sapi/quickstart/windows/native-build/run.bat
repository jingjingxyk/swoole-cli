@echo off

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

call %__PROJECT__%\sapi\quickstart\windows\native-build\config.bat
call %__PROJECT__%\sapi\quickstart\windows\native-build\x_custom_config.bat
call %__PROJECT__%\sapi\quickstart\windows\native-build\build.bat


cd /d %__PROJECT__%
endlocal
