@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\


set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\gettext\

if exist "%__PROJECT__%\build\gettext\.completed" goto :skip

set "VCPKG_ROOT=%__PROJECT__%\var\native-build\vcpkg"
set PATH=%VCPKG_ROOT%;%PATH%

vcpkg install gettext:x64-windows-static

xcopy "%__PROJECT__%\var\native-build\vcpkg\packages\gettext_x64-windows-static\include" "%__PROJECT__%\build\gettext\include" /E /I /H /Y
xcopy "%__PROJECT__%\var\native-build\vcpkg\packages\gettext_x64-windows-static\lib" "%__PROJECT__%\build\gettext\lib" /E /I /H /Y
xcopy "%__PROJECT__%\var\native-build\vcpkg\packages\gettext_x64-windows-static\tools" "%__PROJECT__%\build\gettext\tools" /E /I /H /Y

:: copy /Y "%__PROJECT__%\var\native-build\vcpkg\packages\icu_x64-windows-static\BUILD_INFO" "%__PROJECT__%\build\icu\BUILD_INFO"
:: copy /Y "%__PROJECT__%\var\native-build\vcpkg\packages\icu_x64-windows-static\CONTROL" "%__PROJECT__%\build\icu\CONTROL"

type nul > "%__PROJECT__%\build\gettext\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "gettext build completed ! "

exit /b 0

cd /d %__PROJECT__%
endlocal

