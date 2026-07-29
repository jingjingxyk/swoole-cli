@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%
mkdir  %__PROJECT__%\build\libedit


cd /d %__PROJECT__%\pool\lib\
if not exist libedit-20260512-3.1.tar.gz curl.exe -fSLo libedit-20260512-3.1.tar.gz https://thrysoee.dk/editline/libedit-20260512-3.1.tar.gz

7z.exe x -aoa -y   %__PROJECT__%\pool\lib\libedit-20260512-3.1.tar.gz

if  exist "%__PROJECT__%\thirdparty\libedit" rmdir /s /q "%__PROJECT__%\thirdparty\libedit"
mkdir "%__PROJECT__%\thirdparty\libedit"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\libedit\"  %__PROJECT__%\pool\lib\libedit-20260512-3.1.tar


cd /d "%__PROJECT__%\thirdparty\libedit\libedit-20260512-3.1"
ls .

mkdir %__PROJECT__%\var\native-build\
cd /d %__PROJECT__%\var\native-build\

exit /b 0


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


sed.exe -i.".bak" "217 s/<RuntimeLibrary>MultiThreadedDLL<\/RuntimeLibrary>/<RuntimeLibrary>MultiThreaded<\/RuntimeLibrary>/" .\libiconv_static\libiconv_static.vcxproj

msbuild libiconv.sln /t:libiconv_static:Rebuild /p:Configuration=Release /p:RuntimeLibrary=MultiThreaded /p:Platform=x64 /p:WindowsTargetPlatformVersion=%WindowsSDKLibVersion%  /m

ls x64\lib\

xcopy ..\source\include\iconv.h %__PROJECT__%\build\libiconv\include\* /E /I /H /Y
xcopy x64\lib\*.lib %__PROJECT__%\build\libiconv\lib\* /E /I /H /Y

cd /d %__PROJECT__%

endlocal
