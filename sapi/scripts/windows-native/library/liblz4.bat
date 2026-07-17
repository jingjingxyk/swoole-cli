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
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\lz4-v1.9.4.tar.gz

if  exist "%__PROJECT__%\thirdparty\liblz4" rmdir /s /q "%__PROJECT__%\thirdparty\liblz4"
mkdir "%__PROJECT__%\thirdparty\liblz4"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libyaml"  %__PROJECT__%\pool\lib\lz4-v1.9.4.tar
cd %__PROJECT__%\thirdparty\liblz4\lz4-v1.9.4\

cd build\cmake\
dir
mkdir  build-dir
cd build-dir
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\liblz4" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON  ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DLZ4_POSITION_INDEPENDENT_LIB=ON  ^
-DLZ4_BUILD_LEGACY_LZ4C=ON  ^
-DLZ4_BUILD_CLI=ON

cmake --build . --config Release --target install


cd /d %__PROJECT__%
endlocal
