@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

rem
rem cmd /c var\native-build\php-sdk-binary-tools\phpsdk-starter.bat -c vs17 -a x64  -t .\sapi\scripts\windows-native\library\icu.bat
rem
set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\icu\


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\icu4c-73_2-src.tgz

if  exist "%__PROJECT__%\thirdparty\icu" rmdir /s /q "%__PROJECT__%\thirdparty\icu"
mkdir "%__PROJECT__%\thirdparty\icu"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\icu"  %__PROJECT__%\pool\lib\icu4c-73_2-src
cd %__PROJECT__%\thirdparty\zlib\icu4c-73_2-src\

dir

mkdir build

cd build
dir
echo %cd%


cd /d %__PROJECT__%
endlocal
