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
echo #custom build static link php library  >> %x_makefile%
echo x-build-php-lib^: generated_files  $(PHP_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS) $(STATIC_EXT_OBJS)  $(ASM_OBJS) $(MCFILE) >> %x_makefile%
echo #custom build php.exe  >> %x_makefile%
echo x-release-php^: $(DEPS_CLI) $(CLI_GLOBAL_OBJS) x-build-php-lib $(PHP_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS) $(STATIC_EXT_OBJS) $(ASM_OBJS) $(BUILD_DIR)^\php.exe.res $(BUILD_DIR)^\php.exe.manifest  >> %x_makefile%
rem $(BUILD_DIR)\php.exe: generated_files $(DEPS_CLI) $(PHP_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS) $(STATIC_EXT_OBJS) $(ASM_OBJS) $(BUILD_DIR)\php.exe.res $(BUILD_DIR)\php.exe.manifest
rem		"$(LINK)" /nologo $(PHP_GLOBAL_OBJS_RESP) $(CLI_GLOBAL_OBJS_RESP) $(STATIC_EXT_OBJS_RESP) $(STATIC_EXT_LIBS) $(ASM_OBJS) $(LIBS) $(LIBS_CLI) $(BUILD_DIR)\php.exe.res /out:$(BUILD_DIR)\php.exe $(LDFLAGS) $(LDFLAGS_CLI) /ltcg /nodefaultlib:msvcrt /nodefaultlib:msvcrtd /ignore:4286

rem echo 	^@"$(LINK)" ^/nologo $(PHP_GLOBAL_OBJS) $(PHP_GLOBAL_OBJS_RESP) $(CLI_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS_RESP)  $(STATIC_EXT_OBJS_RESP)  $(STATIC_EXT_OBJS)  $(ASM_OBJS) $(LIBS) $(LIBS_CLI) $(BUILD_DIR)^\php.exe.res /out:$(BUILD_DIR)^\php.exe $(LDFLAGS) $(LDFLAGS_CLI)    >> %x_makefile%
echo 	^@"$(LINK)" ^/nologo $(PHP_GLOBAL_OBJS_RESP) $(CLI_GLOBAL_OBJS_RESP) $(STATIC_EXT_OBJS_RESP)  $(ASM_OBJS) $(LIBS) $(LIBS_CLI) $(STATIC_EXT_LIBS)  $(BUILD_DIR)^\php.exe.res /out:$(BUILD_DIR)^\php.exe $(LDFLAGS) $(LDFLAGS_CLI)    >> %x_makefile%
rem echo 	-@$(_VC_MANIFEST_EMBED_EXE)   >> %x_makefile%
rem echo 	^@echo SAPI sapi\cli build complete  >> %x_makefile%
rem echo 	if exist php.exe.manifest "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x64\mt.exe" -nologo -manifest php.exe.manifest -outputresource:php.exe;1

:x-release-php-end


rem nmake show-variable
nmake x-release-php
rem nmake x-build-php-lib

rem nmake install

cd %__PROJECT__%
endlocal

