@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

rem
rem cmd /c var\native-build\php-sdk-binary-tools\phpsdk-starter.bat -c vs17 -a x64  -t .\sapi\scripts\windows-native\library\zlib.bat
rem
set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%/build/zlib/

set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%
mkdir %__PROJECT__%\thirdparty\zlib
cd /d %__PROJECT__%\thirdparty\zlib
where tar
tar.exe --strip-components=1 -C %__PROJECT__%\thirdparty\zlib -xf %__PROJECT__%\pool\lib\zlib-v1.3.1.tar.gz

dir

mkdir build

cd build
dir
echo %cd%

cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\zlib" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON

cmake --build . --config Release --target install


cd /d %__PROJECT__%
endlocal
