@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\


set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\gmp\

if exist "%__PROJECT__%\build\gmp\.completed" goto :skip


set "VCPKG_ROOT=%__PROJECT__%\var\native-build\vcpkg"
set PATH=%VCPKG_ROOT%;%PATH%
vcpkg install gmp:x64-windows-static


xcopy "%__PROJECT__%\var\native-build\vcpkg\packages\gmp_x64-windows-static\include" "%__PROJECT__%\build\gmp\include" /E /I /H /Y
xcopy "%__PROJECT__%\var\native-build\vcpkg\packages\gmp_x64-windows-static\lib" "%__PROJECT__%\build\gmp\lib" /E /I /H /Y

:: copy /Y "%__PROJECT__%\var\native-build\vcpkg\packages\icu_x64-windows-static\BUILD_INFO" "%__PROJECT__%\build\icu\BUILD_INFO"
:: copy /Y "%__PROJECT__%\var\native-build\vcpkg\packages\icu_x64-windows-static\CONTROL" "%__PROJECT__%\build\icu\CONTROL"

:: type nul > "%__PROJECT__%\build\icu\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "gmp build completed ! "


cd /d %__PROJECT__%
exit /b 0
endlocal

