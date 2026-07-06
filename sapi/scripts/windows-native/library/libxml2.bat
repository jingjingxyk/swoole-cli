@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  build

cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libxml2-v2.9.14.tar.gz

if  exist "%__PROJECT__%\thirdparty\libxml2" rmdir /s /q "%__PROJECT__%\thirdparty\libxml2"
mkdir "%__PROJECT__%\thirdparty\libxml2"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libxml2"  %__PROJECT__%\pool\lib\libxml2-v2.9.14.tar

cd /d %__PROJECT__%\thirdparty\libxml2\libxml2-2.9.14\
dir
echo %cd%

:: exit /b 0


set CL=/MP
mkdir -p build_dir
cd build_dir

:: set "PKG_CONFIG_PATH=C:/vcpkg/packages/libiconv_x64-windows-static/lib/pkgconfig"

cmake ^
cmake -S .. -B . ^
-DBUILD_SHARED_LIBS=OFF ^
-DCMAKE_BUILD_TYPE=Release ^
-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
-DCMAKE_INSTALL_PREFIX=%__PROJECT__%\build ^
-DIconv_ROOT=C:/vcpkg/packages/libiconv_x64-windows-static/ ^
-DLIBXML_STATIC=ON ^
-DLIBXML2_WITH_ZLIB=OFF ^
-DLIBXML2_WITH_LZMA=OFF ^
-DLIBXML2_WITH_ICU=OFF ^
-DLIBXML2_WITH_PYTHON=OFF ^
-DLIBXML2_WITH_TESTS=OFF

cmake --build . --config Release --target install

copy %__PROJECT__%\build\lib\libxml2s.lib %__PROJECT__%\build\lib\libxml2_a.lib

cd /d %__PROJECT__%
endlocal
