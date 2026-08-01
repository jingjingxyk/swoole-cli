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

set "OPENSSL_PREFIX=%__PROJECT__%\build\openssl"
set "LIBNGHTTP2_PREFIX=%__PROJECT__%\build\libnghttp2"
set "LIBPSL_PREFIX=%__PROJECT__%\build\libpsl"
set "LIBZLIB_PREFIX=%__PROJECT__%\build\zlib"
set "LIBSSH2_PREFIX=%__PROJECT__%\build\libssh2"
set "LIBPSL_PREFIX=%__PROJECT__%\build\libpsl"
set "LIBBROTLI_PREFIX=%__PROJECT__%\build\brotli"
set "LIBCURL_PREFIX=%__PROJECT__%\build\curl"
set "LIBZSTD_PREFIX=%__PROJECT__%\build\libzstd"

mkdir  build
cd build
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\curl" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON ^
-DCURL_STATIC_CRT=ON ^
-DCURL_USE_OPENSSL=ON ^
-DCURL_USE_WOLFSSL=OFF ^
-DCURL_USE_GNUTLS=OFF ^
-DCURL_USE_MBEDTLS=OFF ^
-DCURL_USE_LIBSSH2=ON ^
-DUSE_NGHTTP2=ON ^
-DUSE_WIN32_IDN=ON ^
-DZSTD_LIBRARY=%__PROJECT__%\build\libzstd\lib\libzstd_a.lib ^
-DCMAKE_PREFIX_PATH="%OPENSSL_PREFIX%;%LIBZLIB_PREFIX%;%LIBSSH2_PREFIX%;%LIBBROTLI_PREFIX%;%LIBZSTD_PREFIX%;%LIBNGHTTP2_PREFIX%;%LIBPSL_PREFIX%;" ^
-DCMAKE_C_FLAGS="/MT /O2 /W3 /DPSL_STATIC /DNGHTTP2_STATICLIB" ^
-DCMAKE_EXE_LINKER_FLAGS="/VERBOSE:LIB" ^
-DCMAKE_VERBOSE_MAKEFILE=ON

:: -DENABLE_UNICODE=ON

cmake --build . --config Release --target install

copy /Y %__PROJECT__%\build\curl\lib\libcurl.lib "%__PROJECT__%\build\curl\lib\libcurl_a.lib"

dumpbin /DIRECTIVES "%__PROJECT__%\build\curl\lib\libcurl.lib" | findstr /i "DEFAULTLIB"

cd /d %__PROJECT__%
endlocal
