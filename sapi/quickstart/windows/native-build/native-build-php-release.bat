@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd %__PROJECT__%\php-src\

set "INCLUDE=%INCLUDE%;%__PROJECT__%\openssl\include\;%__PROJECT__%\zlib\include"
set "LIB=%LIB%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib"
set "LIBPATH=%LIBPATH%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib\"

set CL=/MP
rem set RTLIBCFG=static
rem nmake   mode=static debug=false

rem nmake all


set x_makefile=%__PROJECT__%\php-src\Makefile



findstr /C:"x-release-php: " %x_makefile%
findstr /C:"x-release-php: " %x_makefile% >nul

if errorlevel 1 (
echo custom makefile x-release-php config!
goto x-release-php-start
) else (
echo custom makefile file exits !
goto x-release-php-end
)

:x-release-php-start
echo #show variable  >> %x_makefile%
echo show-variable:   >> %x_makefile%
echo 	^@echo DEPS_CLI: $(DEPS_CLI)  >> %x_makefile%
echo 	^@echo ==================  >> %x_makefile%
echo 	^@echo CLI_GLOBAL_OBJ: $(CLI_GLOBAL_OBJS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
rem echo 	^@echo PHP_GLOBAL_OBJS: $(PHP_GLOBAL_OBJS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
rem echo 	^@echo STATIC_EXT_OBJS: $(STATIC_EXT_OBJS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo ASM_OBJS: $(ASM_OBJS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo STATIC_EXT_LIBS: $(STATIC_EXT_LIBS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo STATIC_EXT_LDFLAGS: $(STATIC_EXT_LDFLAGS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo STATIC_EXT_CFLAGS: $(STATIC_EXT_CFLAGS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo BUILD_DIR\PHPLIB: $(BUILD_DIR)\$(PHPLIB) >> %x_makefile%
echo 	^@echo ==================  >> %x_makefile%
echo 	^@echo CLI_GLOBAL_OBJS_RESP: $(CLI_GLOBAL_OBJS_RESP)  >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo LIBS_CLI: $(LIBS_CLI) >> %x_makefile%
echo 	^@echo ==================  >> %x_makefile%
echo 	^@echo LDFLAGS: $(LDFLAGS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo LDFLAGS_CLI: $(LDFLAGS_CLI)  >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo _VC_MANIFEST_EMBED_EXE: $(_VC_MANIFEST_EMBED_EXE)  >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo PHPDEF: $(PHPDEF) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo PHPDLL_RES: $(PHPDLL_RES) >> %x_makefile%
echo 	^@echo ==================  >> %x_makefile%
echo 	^@echo ASM_OBJS: $(ASM_OBJS) >> %x_makefile%
echo 	^@echo ================== >> %x_makefile%
echo 	^@echo MCFILE: $(MCFILE) >> %x_makefile%
echo 	^@echo ==================   >> %x_makefile%
echo #custom build static link php library  >> %x_makefile%
echo x-build-php-lib^: generated_files  $(PHP_GLOBAL_OBJS) $(STATIC_EXT_OBJS)  $(ASM_OBJS) $(MCFILE) >> %x_makefile%
echo #custom build static link php 1  >> %x_makefile%
$(BUILD_DIR)\php.exe: generated_files $(DEPS_CLI) $(PHP_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS) $(STATIC_EXT_OBJS) $(ASM_OBJS) $(BUILD_DIR)\php.exe.res $(BUILD_DIR)\php.exe.manifest

echo x-release-php^: $(DEPS_CLI) $(CLI_GLOBAL_OBJS) x-build-php-lib $(PHP_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS) $(STATIC_EXT_OBJS) $(ASM_OBJS) $(BUILD_DIR)^\php.exe.res $(BUILD_DIR)^\php.exe.manifest  >> %x_makefile%
echo 	^@"$(LINK)" ^/nologo  $(CLI_GLOBAL_OBJS_RESP)  $(LIBS_CLI) $(BUILD_DIR)^\php.exe.res /out:$(BUILD_DIR)^\php.exe $(LDFLAGS) $(LDFLAGS_CLI)    >> %x_makefile%
echo 	-@$(_VC_MANIFEST_EMBED_EXE)   >> %x_makefile%
echo 	^@echo SAPI sapi\cli build complete  >> %x_makefile%
echo 	if exist php.exe.manifest "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x64\mt.exe" -nologo -manifest php.exe.manifest -outputresource:php.exe;1

:x-release-php-end


rem nmake show-variable
nmake x-release-php

rem nmake install

cd %__PROJECT__%
endlocal
