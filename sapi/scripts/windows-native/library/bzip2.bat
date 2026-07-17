@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\bzip2\
mkdir  %__PROJECT__%\build\bzip2\include\
mkdir  %__PROJECT__%\build\bzip2\lib\


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\bzip2-1.0.8.tar.gz

if  exist "%__PROJECT__%\thirdparty\bzip2" rmdir /s /q "%__PROJECT__%\thirdparty\bzip2"
mkdir "%__PROJECT__%\thirdparty\bzip2"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\bzip2"  %__PROJECT__%\pool\lib\bzip2-1.0.8.tar
cd %__PROJECT__%\thirdparty\bzip2\bzip2-1.0.8\

dir

set "CFLAGS=/EHsc /MP /MT "
set CL=/MP

nmake -f makefile.msc

copy /Y *.h "%__PROJECT__%\build\bzip2\include\"
copy /Y *.lib "%__PROJECT__%\build\bzip2\lib\"

:: vcpkg install bzip2:x64-windows-static

cd /d %__PROJECT__%
endlocal
