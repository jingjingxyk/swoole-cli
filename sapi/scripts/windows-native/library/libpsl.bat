@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  build\libpsl
set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libpsl-0.21.5.tar.gz

if  exist "%__PROJECT__%\thirdparty\libpsl" rmdir /s /q "%__PROJECT__%\thirdparty\libpsl"
mkdir "%__PROJECT__%\thirdparty\libpsl"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libpsl"  %__PROJECT__%\pool\lib\libpsl-0.21.5.tar
cd %__PROJECT__%\thirdparty\libpsl\libpsl-0.21.5\

dir

:: vcpkg install libpsl:x64-windows-static

cd msvc

nmake /f Makefile.vc CFG=release DISABLE_BUILTIN=1 DISABLE_RUNTIME=1 STATIC=1 PREFIX="%__PROJECT__%\libpsl" install




cd /d %__PROJECT__%
endlocal
