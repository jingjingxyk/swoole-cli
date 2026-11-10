@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  "%__PROJECT__%\build\libsodium"

if exist "%__PROJECT__%\build\libsodium\.completed" goto :skip

set "VCPKG_ROOT=%__PROJECT__%\var\native-build\vcpkg"
set PATH=%VCPKG_ROOT%;%PATH%

vcpkg install libsodium
vcpkg integrate install
:: copy /Y "%LIBSODIUM_PREFIX%\lib\onig.lib" "%ONIGURUMA_PREFIX%\lib\libonig_a.lib"
:: copy /Y "%LIBSODIUM_PREFIX%\lib\onig.lib" "%ONIGURUMA_PREFIX%\lib\onig_a.lib"

type nul > "%__PROJECT__%\build\libsodium\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "libsodium build completed ! "

endlocal
