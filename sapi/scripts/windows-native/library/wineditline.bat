@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\wineditline

if exist "%__PROJECT__%\build\wineditline\.completed" goto :skip


mkdir %__PROJECT__%\var\native-build\
cd /d %__PROJECT__%\var\native-build\


:: https://github.com/larkmjc/libedit.git
if not exist "wineditline" (
   git clone -b wineditline-2.208 https://github.com/ptosco/wineditline.git wineditline
)

if  exist "%__PROJECT__%\thirdparty\wineditline" rmdir /s /q "%__PROJECT__%\thirdparty\wineditline"
mkdir "%__PROJECT__%\thirdparty\wineditline"

xcopy wineditline %__PROJECT__%\thirdparty\wineditline /E /I /H /Y

cd "%__PROJECT__%\thirdparty\wineditline"


if exist "build_static" (
    rmdir /S /Q build_static
)

mkdir  build_static
cmake -B build_static -S . ^
  -G"MSYS Makefiles" ^
  -DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\wineditline" ^
  -DCMAKE_BUILD_TYPE=Release  ^
  -DBUILD_SHARED_LIBS=OFF  ^
  -DBUILD_STATIC_LIBS=ON  ^
  -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
  -DCMAKE_VERBOSE_MAKEFILE=ON

cmake --build build_static --config Release --target install


:: type nul > "%__PROJECT__%\build\wineditline\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "wineditline build completed ! "

exit /b 0

cd /d %__PROJECT__%

endlocal
