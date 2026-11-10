@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  "%__PROJECT__%\build\libsodium"

if exist "%__PROJECT__%\build\libsodium\.completed" goto :skip

set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libsodium-1.0.21.tar.gz

if  exist "%__PROJECT__%\thirdparty\libsodium" rmdir /s /q "%__PROJECT__%\thirdparty\libsodium"
mkdir "%__PROJECT__%\thirdparty\libsodium"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libsodium"  %__PROJECT__%\pool\lib\libsodium-1.0.21.tar
cd %__PROJECT__%\thirdparty\libsodium\libsodium-1.0.21\

dir

set "LIBSODIUM_PREFIX=%__PROJECT__%\build\libsodium"

mkdir  build-dir
cd build-dir
cmake .. ^
-DCMAKE_INSTALL_PREFIX="%LIBSODIUM_PREFIX%" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON  ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DMSVC_STATIC_RUNTIME=ON ^
-DCMAKE_C_FLAGS="/MT /O2 /W3 /DNDEBUG" ^
-DCMAKE_VERBOSE_MAKEFILE=ON ^
-DENABLE_TESTING=OFF ^

cmake --build . --config Release
cmake --build . --config Release --target install


copy /Y "%ONIGURUMA_PREFIX%\lib\onig.lib" "%ONIGURUMA_PREFIX%\lib\libonig_a.lib"
copy /Y "%ONIGURUMA_PREFIX%\lib\onig.lib" "%ONIGURUMA_PREFIX%\lib\onig_a.lib"

type nul > "%__PROJECT__%\build\libsodium\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "libsodium build completed ! "

endlocal
