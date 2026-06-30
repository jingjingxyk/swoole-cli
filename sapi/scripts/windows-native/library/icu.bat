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

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\icu"  %__PROJECT__%\pool\lib\icu4c-73_2-src.tar
cd %__PROJECT__%\thirdparty\icu\icu\

dir

set "PATH=%__PROJECT__%\runtime\nasm\;C:\Strawberry\perl\bin;%PATH%"
set "PATH=%ProgramFiles%\7-Zip;%PATH%;"
set "PATH=%__PROJECT__%\var\native-build\php-sdk-binary-tools\bin\;%__PROJECT__%\var\native-build\php-sdk-binary-tools\msys2\bin;%PATH%;"
echo "%PATH%"



where link.exe

cmd /c "cd /d \"C:\Program Files\Git\usr\bin\" && rename link.exe link.exe.exe"

cd %__PROJECT__%\thirdparty\icu\icu\


set "CPPFLAGS=-D U_CHARSET_IS_UTF8=1  -D U_USING_ICU_NAMESPACE=1  -D U_STATIC_IMPLEMENTATION=1 "
bash ./source/runConfigureICU MSYS/MSVC --prefix=D:/a/swoole-cli/swoole-cli/build/icu/ ^
--enable-static=yes ^
--enable-shared=no ^
--with-data-packaging=static ^
--enable-release=yes ^
--enable-extras=yes ^
--enable-icuio=yes ^
--enable-dyload=no ^
--enable-tools=yes ^
--enable-tests=no ^
--enable-samples=no

make -j %NUMBER_OF_PROCESSORS%
make install
cmd /c 'cd /d "C:\Program Files\Git\usr\bin\" && rename link.exe.bak link.exe'


cd /d %__PROJECT__%
endlocal

