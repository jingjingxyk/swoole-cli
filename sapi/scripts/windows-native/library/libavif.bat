@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\libavif


if exist "%__PROJECT__%\build\libavif\.completed" goto :skip


mkdir %__PROJECT__%\var\native-build
cd /d %__PROJECT__%\var\native-build


set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%


cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libwebp-v1.3.2.tar.gz

if  exist "%__PROJECT__%\thirdparty\libavif" rmdir /s /q "%__PROJECT__%\thirdparty\libavif"
mkdir "%__PROJECT__%\thirdparty\libavif"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libavif"  %__PROJECT__%\pool\lib\libwebp-v1.3.2.tar
cd %__PROJECT__%\thirdparty\libavif\libwebp-1.3.2

dir

set "PATH=%__PROJECT__%\runtime\nasm;%PATH%;"

if exist "build_static" (
    rmdir /S /Q build_static
)

mkdir  build_static
cmake -B build_static -S . ^
	-DCMAKE_INSTALL_PREFIX="%__PROJECT__%\build\libavif" ^
	-DCMAKE_BUILD_TYPE=Release  ^
	-DBUILD_SHARED_LIBS=OFF  ^
	-DBUILD_STATIC_LIBS=ON  ^
	-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
	-DCMAKE_C_FLAGS="/MT /O2 /W3 /DNDEBUG" ^
	-DCMAKE_C_FLAGS_RELEASE="/MT /O2 /W3 /DNDEBUG" ^
	-DCMAKE_PREFIX_PATH="%__PROJECT__%\build\zlib;%__PROJECT__%\build\libjpeg;%__PROJECT__%\build\libpng;%__PROJECT__%\build\libgif" ^
	-DCMAKE_VERBOSE_MAKEFILE=ON

         -DAVIF_BUILD_EXAMPLES=OFF \
            -Dsvt_ROOT={$svt_av1_prefix} \
            -Daom_ROOT={$aom_prefix} \
            -Dlibgav1_ROOT={$libgav1_prefix} \
            -Ddav1d_ROOT={$dav1d_prefix} \
            -Dlibyuv_ROOT={$libyuv_prefix} \
            -DAVIF_CODEC_AOM=SYSTEM \
            -DAVIF_CODEC_DAV1D=SYSTEM \
            -DAVIF_CODEC_LIBGAV1=SYSTEM \
            -DAVIF_CODEC_RAV1E=OFF \
            -DAVIF_CODEC_SVT=SYSTEM



cmake --build build_static --config Release --target install

copy /Y "%__PROJECT__%\build\libavif\lib\libwebp.lib" "%__PROJECT__%\build\libavif\lib\libwebp_a.lib"
rem  Compatible with PHP build detection
xcopy "%__PROJECT__%\build\libavif\include" "%__PROJECT__%\build\include" /E /I /H /Y


type nul > "%__PROJECT__%\build\libavif\.completed"

cd /d %__PROJECT__%
goto :ok

:skip
echo "skip build step"
goto :ok

:ok
echo "libavif build completed ! "

exit /b 0

cd /d %__PROJECT__%

endlocal
