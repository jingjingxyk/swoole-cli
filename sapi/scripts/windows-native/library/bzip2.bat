@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  build

set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\bzip2-1.0.8.tar.gz

if  exist "%__PROJECT__%\thirdparty\bzip2" rmdir /s /q "%__PROJECT__%\thirdparty\bzip2"
mkdir "%__PROJECT__%\thirdparty\bzip2"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\bzip2"  %__PROJECT__%\pool\lib\bzip2-1.0.8.tar
cd %__PROJECT__%\thirdparty\bzip2\bzip2-1.0.8\

dir

set "CFLAGS=/EHsc /MP /MT "

nmake -f makefile.msc
nmake install DESTDIR="%__PROJECT__%\build\bzip2"

:: vcpkg install bzip2:x64-windows-static

cd /d %__PROJECT__%
endlocal
