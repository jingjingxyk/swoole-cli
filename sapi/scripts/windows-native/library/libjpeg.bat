@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\libpng


if exist "%__PROJECT__%\build\libpng\.completed" goto :skip


mkdir %__PROJECT__%\var\native-build
cd /d %__PROJECT__%\var\native-build


set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\freetype-2.13.2.tar.gz

if  exist "%__PROJECT__%\thirdparty\libpng" rmdir /s /q "%__PROJECT__%\thirdparty\libpng"
mkdir "%__PROJECT__%\thirdparty\libpng"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libpng"  %__PROJECT__%\pool\lib\freetype-2.13.2.tar.gz
cd %__PROJECT__%\thirdparty\libpng\freetype-2.13.2

dir



if exist "build_static" (
    rmdir /S /Q build_static
)

mkdir  build_static
cmake -B build_static -S . ^
  -DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\libpng" ^
  -DCMAKE_BUILD_TYPE=Release  ^
  -DBUILD_SHARED_LIBS=OFF  ^
  -DBUILD_STATIC_LIBS=ON  ^
  -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^

  -DCMAKE_VERBOSE_MAKEFILE=ON

              -DCMAKE_INSTALL_PREFIX={$libjpeg_prefix} \
              -DCMAKE_INSTALL_LIBDIR={$libjpeg_prefix}/lib \
              -DCMAKE_INSTALL_INCLUDEDIR={$libjpeg_prefix}/include \
              -DCMAKE_BUILD_TYPE=Release  \
              -DBUILD_SHARED_LIBS=OFF  \
              -DBUILD_STATIC_LIBS=ON \
              -DENABLE_SHARED=OFF  \
              -DENABLE_STATIC=ON \

:: -DCMAKE_POLICY_DEFAULT_CMP0074=NEW



cmake --build build_static --config Release --target install

::xcopy "%__PROJECT__%\thirdparty\libpng\include" "%__PROJECT__%\build\freetype\include" /E /I /H /Y

:: copy /Y "%__PROJECT__%\thirdparty\freetype\lib64\edit_static.lib" "%__PROJECT__%\build\freetype\lib\edit_a.lib"
:: copy /Y "%__PROJECT__%\thirdparty\freetype\lib64\edit_static.lib" "%__PROJECT__%\build\freetype\lib\edit.lib"


:: type nul > "%__PROJECT__%\build\libpng\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "libpng build completed ! "

exit /b 0

cd /d %__PROJECT__%

endlocal
