@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\


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

set "ORIGIN_PATH=%PATH%"
set "PATH=%__PROJECT__%\runtime\nasm\;"
set "PATH=C:\cygwin64\bin\;%PATH%;"
:: set "PATH=%__PROJECT__%\var\native-build\php-sdk-binary-tools\bin\;%__PROJECT__%\var\native-build\php-sdk-binary-tools\msys2\bin;%PATH%;"
set "PATH=%PATH%;%ORIGIN_PATH%"
echo "%PATH%"



where link.exe

mkdir %__PROJECT__%\backup\
if exist "C:\Program Files\Git\usr\bin\link.exe" (
   move "C:\Program Files\Git\usr\bin\link.exe"  %__PROJECT__%\backup\git-link.exe
)

if exist "C:\cygwin64\bin\link.exe" (
   move "C:\cygwin64\bin\link.exe" %__PROJECT__%\backup\cygwin-link.exe
)



cd %__PROJECT__%\thirdparty\icu\icu\

:: exit /b 0

:: set "CXXFLAGS=/MT"
:: set "CFLAGS=/EHsc /MP /MT /UCRT"
set "CFLAGS=/EHsc /MP /MT"
set "CXXFLAGS=/MT"

set "CPPFLAGS=-D U_CHARSET_IS_UTF8=1  -D U_USING_ICU_NAMESPACE=1  -D U_STATIC_IMPLEMENTATION=1 "

sed.exe -i.".bak" "s/RELEASE_CFLAGS='-Gy -MD'/RELEASE_CFLAGS='-Gy -MT'/" .\source\runConfigureICU
sed.exe -i.".bak" "s/RELEASE_CXXFLAGS='-Gy -MD'/RELEASE_CXXFLAGS='-Gy -MT'/" .\source\runConfigureICU

bash ./source/runConfigureICU Cygwin/MSVC --prefix=/cygdrive/d/a/swoole-cli/swoole-cli/build/icu/ ^
--enable-static=yes ^
--enable-shared=no ^
--with-data-packaging=static ^
--enable-release=yes ^
--enable-extras=yes ^
--enable-icuio=yes ^
--enable-dyload=no ^
--enable-tools=no ^
--enable-tests=no ^
--enable-samples=no

make -j %NUMBER_OF_PROCESSORS%
make install

if exist %__PROJECT__%\backup\git-link.exe (
   move  %__PROJECT__%\backup\git-link.exe "C:\Program Files\Git\usr\bin\link.exe"
)

if exist %__PROJECT__%\backup\cygwin-link.exe (
   move %__PROJECT__%\backup\cygwin-link.exe "C:\cygwin64\bin\link.exe"
)

cd /d %__PROJECT__%
endlocal

