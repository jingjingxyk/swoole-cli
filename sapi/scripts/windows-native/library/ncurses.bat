@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%



cd /d %__PROJECT__%\pool\lib\
7z.exe x -aoa -y   %__PROJECT__%\pool\lib\ncurses-6.3.tar.gz

if  exist "%__PROJECT__%\thirdparty\ncurses" rmdir /s /q "%__PROJECT__%\thirdparty\ncurses"
mkdir "%__PROJECT__%\thirdparty\ncurses"

7z.exe x -aoa -y  -o"%__PROJECT__%\thirdparty\ncurses"  %__PROJECT__%\pool\lib\ncurses-6.3.tar

cd /d %__PROJECT__%\thirdparty\ncurses\ncurses-6.3\
dir
echo %cd%

set "VCPKG_ROOT=%__PROJECT__%\var\native-build\vcpkg"
set PATH=%VCPKG_ROOT%;%PATH%

vcpkg install pdcurses


exit /b 0

set CFLAGS="/EHsc /MP  /MT"
set CXXFLAGS="/MT"
set CPPFLAGS="-DNCURSES_STATIC"

.\configure ^
--CC=cl ^
--CXX=cl ^
--prefix="%__PROJECT__%\build\ncurses" ^
--enable-static ^
--disable-shared ^
--with-normal ^
--enable-widec ^
--enable-echo ^
--with-ticlib  ^
--without-termlib ^
--enable-sp-funcs ^
--enable-term-driver ^
--enable-ext-colors ^
--enable-ext-mouse ^
--enable-ext-putwin ^
--enable-no-padding ^
--without-debug ^
--without-tests ^
--without-dlsym ^
--without-debug ^
--enable-symlinks

make -j %NUMBER_OF_PROCESSORS%
make install

cd /d %__PROJECT__%
endlocal
