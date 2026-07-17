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
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\brotli-1.0.9.tar.gz

if  exist "%__PROJECT__%\thirdparty\brotli" rmdir /s /q "%__PROJECT__%\thirdparty\brotli"
mkdir "%__PROJECT__%\thirdparty\brotli"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\brotli"  %__PROJECT__%\pool\lib\brotli-1.0.9.tar
cd %__PROJECT__%\thirdparty\brotli\brotli-1.0.9\

dir
mkdir  build-dir
cd build-dir
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\brotli" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON  ^
-DBROTLI_DISABLE_TESTS=OFF  ^
-DBROTLI_BUNDLED_MODE=OFF

cmake --build . --config Release --target install

cd /d %__PROJECT__%
endlocal
