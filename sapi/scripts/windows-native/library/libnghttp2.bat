@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  build
set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\nghttp2-1.68.0.tar.gz

if  exist "%__PROJECT__%\thirdparty\nghttp2" rmdir /s /q "%__PROJECT__%\thirdparty\nghttp2"
mkdir "%__PROJECT__%\thirdparty\nghttp2"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\nghttp2"  %__PROJECT__%\pool\lib\nghttp2-1.68.0.tar
cd %__PROJECT__%\thirdparty\nghttp2\nghttp2-1.68.0\


dir
mkdir  build-dir
cd build-dir
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\nghttp2" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON

cmake --build . --config Release --target install


cd /d %__PROJECT__%
endlocal
