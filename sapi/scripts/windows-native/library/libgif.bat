@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  "%__PROJECT__%\build\libgif"

if exist "%__PROJECT__%\build\libgif\.completed" goto :skip

set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\giflib-5.2.1.tar.gz

if  exist "%__PROJECT__%\thirdparty\libgif" rmdir /s /q "%__PROJECT__%\thirdparty\libgif"
mkdir "%__PROJECT__%\thirdparty\libgif"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libgif"  %__PROJECT__%\pool\lib\giflib-5.2.1.tar
cd %__PROJECT__%\thirdparty\libgif\giflib-5.2.1

copy /Y "%__PROJECT__%\sapi\scripts\windows-native\library\patches\libgif-CMakeLists.txt" CMakeLists.txt

dir


mkdir  build_static
cmake -B build_static -S . ^
-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\libgif" ^
-DCMAKE_BUILD_TYPE=Release  ^
-DBUILD_SHARED_LIBS=OFF  ^
-DBUILD_STATIC_LIBS=ON  ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DCMAKE_C_FLAGS="/MT /O2 /W3 /DNDEBUG -D_CRT_SECURE_NO_WARNINGS " ^
-DCMAKE_C_FLAGS_RELEASE="/MT /O2 /W3 /DNDEBUG"

cmake --build build_static --config Release --target install

:: copy /Y "%__PROJECT__%\build\brotli\lib\brotlienc-static.lib" "%__PROJECT__%\build\brotli\lib\brotlienc.lib"

:: type nul > "%__PROJECT__%\build\libgif\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "libgif build completed ! "

endlocal

