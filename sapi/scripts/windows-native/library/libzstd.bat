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
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\zstd-1.5.2.tar.gz

if  exist "%__PROJECT__%\thirdparty\libzstd" rmdir /s /q "%__PROJECT__%\thirdparty\libzstd"
mkdir "%__PROJECT__%\thirdparty\libzstd"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libyaml"  %__PROJECT__%\pool\lib\zstd-1.5.2.tar
cd %__PROJECT__%\thirdparty\libzstd\zstd-1.5.2\

cd thirdparty\libzstd\build\cmake\
dir

set "LIBLZ4_PREFIX=%__PROJECT__%\build\liblz4"
set "LIBLZMA_PREFIX=%__PROJECT__%\build\liblzma"
set "LIBZLIB_PREFIX=%__PROJECT__%\build\zlib"

mkdir  build-dir
cd build-dir
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\libzstd" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DZSTD_BUILD_CONTRIB=OFF ^
-DZSTD_BUILD_PROGRAMS=ON ^
-DZSTD_BUILD_TESTS=OFF ^
-DZSTD_LEGACY_SUPPORT=ON ^
-DZSTD_MULTITHREAD_SUPPORT=ON ^
-DZSTD_ZLIB_SUPPORT=ON ^
-DZSTD_LZMA_SUPPORT=ON ^
-DZSTD_LZ4_SUPPORT=ON ^
-DZLIB_ROOT="%LIBZLIB_PREFIX%" ^
-DLibLZMA_ROOT="%LIBLZMA_PREFIX%" ^
-DLibLZ4_ROOT="%LIBLZ4_PREFIX%" ^
-DCMAKE_PREFIX_PATH="%LIBLZ4_PREFIX%;%LIBLZMA_PREFIX%;%LIBZLIB_PREFIX%;"


cmake --build . --config Release --target install


cd /d %__PROJECT__%
endlocal
