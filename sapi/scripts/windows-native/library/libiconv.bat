@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  build

cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libiconv-1.17.tar.gz

if  exist "%__PROJECT__%\thirdparty\libiconv" rmdir /s /q "%__PROJECT__%\thirdparty\libiconv"
mkdir "%__PROJECT__%\thirdparty\libiconv"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libiconv"  %__PROJECT__%\pool\lib\libiconv-1.17.tar

cd /d %__PROJECT__%\thirdparty\libiconv\libiconv-1.17\
dir
echo %cd%

set CL=/MP

set "VCPKG_ROOT=%__PROJECT__%\var\native-build\vcpkg"
set PATH=%VCPKG_ROOT%;%PATH%

vcpkg install libiconv:x64-windows-static

rem C:/vcpkg/packages/libxml2_x64-windows-static/lib/

cd /d %__PROJECT__%
endlocal
