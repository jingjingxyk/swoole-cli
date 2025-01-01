@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%


cd %__PROJECT__%\var\windows-build-deps\php-src\
dir

rem set "INCLUDE=%INCLUDE%;%__PROJECT__%\openssl\include\;%__PROJECT__%\zlib\include"
rem set "LIB=%LIB%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib"
rem set "LIBPATH=%LIBPATH%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib\"

set CL=/MP
rem set RTLIBCFG=static
rem nmake   mode=static debug=false

rem nmake all


set X_MAKEFILE=%__PROJECT__%\var\windows-build-deps\php-src\Makefile



findstr /C:"x-show-var: " %X_MAKEFILE%
findstr /C:"x-show-var: " %X_MAKEFILE% > nul

if errorlevel 1 (
	echo custom MAKEFILE x-show-var config!
	goto x-release-php-start
) else (
	echo custom MAKEFILE file exits !
	goto x-release-php-end
)

:x-release-php-start

echo x-show-var:                                          >> %X_MAKEFILE%
echo 	^@echo DEPS_CLI: $(DEPS_CLI)                      >> %X_MAKEFILE%
echo 	^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo CLI_GLOBAL_OBJ: $(CLI_GLOBAL_OBJS)         >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo ASM_OBJS: $(ASM_OBJS)                      >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo STATIC_EXT_LIBS: $(STATIC_EXT_LIBS)        >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo STATIC_EXT_LDFLAGS: $(STATIC_EXT_LDFLAGS)  >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo STATIC_EXT_CFLAGS: $(STATIC_EXT_CFLAGS)    >> %X_MAKEFILE%
echo    ^@echo ==================                         >> %X_MAKEFILE%
echo    ^@echo BUILD_DIR\PHPLIB: $(BUILD_DIR)\$(PHPLIB)   >> %X_MAKEFILE%
echo    ^@echo ==================                             >> %X_MAKEFILE%
echo    ^@echo CLI_GLOBAL_OBJS_RESP: $(CLI_GLOBAL_OBJS_RESP)  >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo PHP_LDFLAGS: $(PHP_LDFLAGS)  >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo LIBS: $(LIBS)                >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo LIBS_CLI: $(LIBS_CLI)        >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo LDFLAGS: $(LDFLAGS)          >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo LDFLAGS_CLI: $(LDFLAGS_CLI)  >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo _VC_MANIFEST_EMBED_EXE: $(_VC_MANIFEST_EMBED_EXE) >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo PHPDEF: $(PHPDEF)            >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo PHPDLL_RES: $(PHPDLL_RES)    >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo ASM_OBJS: $(ASM_OBJS)        >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%
echo    ^@echo MCFILE: $(MCFILE)            >> %X_MAKEFILE%
echo    ^@echo ==================           >> %X_MAKEFILE%



:x-release-php-end


rem nmake show-variable
nmake x-show-var

rem nmake install

cd %__PROJECT__%
endlocal
=======
cd %__PROJECT__%\var\windows-build-deps\php-src\

where sed.exe

dir  %__PROJECT__%\var\windows-build-deps\php-sdk-binary-tools\msys2\usr\bin\



:: vswhere.exe -products* -requires
:: vswhere.exe -legacy -prerelease -format json
:: vswhere.exe -legacy -prerelease -format json | jq

:: vswhere.exe -legacy -prerelease

nmake /E /f Makefile x-show-var

cd %__PROJECT__%
endlocal

