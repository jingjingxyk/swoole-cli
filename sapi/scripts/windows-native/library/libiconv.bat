@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\libiconv\lib\
mkdir  %__PROJECT__%\build\libiconv\include\


:: cd /d %__PROJECT__%\pool\lib\
:: 7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libiconv-1.17.tar.gz
::7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libiconv"  %__PROJECT__%\pool\lib\libiconv-1.17.tar
:: cd /d %__PROJECT__%\thirdparty\libiconv\libiconv-1.17\

mkdir %__PROJECT__%\var\native-build\
cd /d %__PROJECT__%\var\native-build\

if not exist "libiconv\winlibs.mak" git clone -b libiconv-1.19 https://github.com/winlibs/libiconv.git

if  exist "%__PROJECT__%\thirdparty\libiconv" rmdir /s /q "%__PROJECT__%\thirdparty\libiconv"

xcopy "libiconv" "%__PROJECT__%\thirdparty\libiconv" /E /I /H /Y

cd /d %__PROJECT__%\thirdparty\libiconv\
dir
echo %cd%

set CL=/MP

:: set "VCPKG_ROOT=%__PROJECT__%\var\native-build\vcpkg"
:: set PATH=%VCPKG_ROOT%;%PATH%

:: vcpkg install libiconv:x64-windows-static
rem C:/vcpkg/packages/libxml2_x64-windows-static/lib/
echo "MSVC%PHP_SDK_VS_NUM%"
cd "MSVC%PHP_SDK_VS_NUM%"
:: libiconv.sln
msbuild libiconv.sln /t:Rebuild /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10.0.19041.0
xcopy ..\source\include\iconv.h %__PROJECT__%\build\libiconv\include\*
xcopy x64\lib\*.lib %__PROJECT__%\build\libiconv\lib\*


cd /d %__PROJECT__%
endlocal
