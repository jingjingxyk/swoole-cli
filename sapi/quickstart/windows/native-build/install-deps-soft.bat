@echo off

rem chcp 65001

cmd /c "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

setlocal
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d .\..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%


rem silent installation msi
rem msiexec /i strawberry-perl-5.38.2.2-64bit.msi /quiet

msiexec /i strawberry-perl-5.38.2.2-64bit.msi  /passive


set "PATH=%PATH%;%__PROJECT__%\php\;%__PROJECT__%\nasm\;C:\Strawberry\perl\bin;"
echo %PATH%

rem powershell "add-appxpackage .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
rem winget install nasm -i

cd %__PROJECT__%\nasm

nmake /f Mkfiles/msvc.mak
nmake install

cd %__PROJECT__%

perl -v
php -v
nasm -v


endlocal
