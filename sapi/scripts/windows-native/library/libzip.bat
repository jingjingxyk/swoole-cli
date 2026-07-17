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
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libzip-1.11.4.tar.gz

if  exist "%__PROJECT__%\thirdparty\libzip" rmdir /s /q "%__PROJECT__%\thirdparty\libzip"
mkdir "%__PROJECT__%\thirdparty\libzip"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libzip"  %__PROJECT__%\pool\lib\libzip-1.11.4.tar
cd %__PROJECT__%\thirdparty\libzip\libzip-1.11.4\

dir
mkdir  build-dir
cd build-dir
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\libzip" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded

cmake --build . --config Release --target install


cd /d %__PROJECT__%
endlocal
