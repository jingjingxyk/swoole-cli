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
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\curl-8.16.0.tar.gz

if  exist "%__PROJECT__%\thirdparty\curl" rmdir /s /q "%__PROJECT__%\thirdparty\curl"
mkdir "%__PROJECT__%\thirdparty\curl"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\curl"  %__PROJECT__%\pool\lib\curl-8.16.0.tar

cd /d %__PROJECT__%\thirdparty\curl\curl-8.16.0\

cd thirdparty\curl
dir

mkdir  build
cd build
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\curl" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON ^
-DSSL_ENABLED=ON ^
-DCURL_USE_OPENSSL=ON ^
-DCURL_USE_ZLIB=ON ^
-DCURL_USE_WOLFSSL=OFF ^
-DCURL_USE_GNUTLS=OFF ^
-DCURL_USE_MBEDTLS=OFF ^
-DENABLE_WEBSOCKETS=OFF ^
-DCURL_USE_LIBSSH2=ON ^
-DCMAKE_PREFIX_PATH="%__PROJECT__%\build\openssl;%__PROJECT__%\build\zlib;%__PROJECT__%\build\libssh2;%__PROJECT__%\build\brotli;%__PROJECT__%\build\libzstd;"


cmake --build . --config Release --target install


cd /d %__PROJECT__%
endlocal
