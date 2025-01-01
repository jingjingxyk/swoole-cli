@echo off

setlocal enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%
cd %__PROJECT__%\var\windows-build-deps\php-src\

rem set "INCLUDE=%INCLUDE%;%__PROJECT__%\openssl\include\;%__PROJECT__%\zlib\include"
rem set "LIB=%LIB%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib"
rem set "LIBPATH=%LIBPATH%;%__PROJECT__%\openssl\lib\;%__PROJECT__%\zlib\lib\"

set CL=/MP
rem set RTLIBCFG=static
rem nmake   mode=static debug=false

rem nmake all


set X_MAKEFILE=%__PROJECT__%\var\windows-build-deps\php-src\Makefile


findstr /C:"x-release-php: " %X_MAKEFILE% >nul

if errorlevel 1 (
echo custom MAKEFILE x-release-php config!
goto x-release-php-start
) else (
echo custom MAKEFI file exits !
goto x-release-php-end
)

:x-release-php-start


echo x-build-php-lib^: generated_files  $(PHP_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS) $(STATIC_EXT_OBJS)  $(ASM_OBJS) $(MCFILE) >> %X_MAKEFILE%
echo x-release-php^: $(DEPS_CLI) $(CLI_GLOBAL_OBJS) x-build-php-lib $(PHP_GLOBAL_OBJS)  $(STATIC_EXT_OBJS) $(ASM_OBJS) $(BUILD_DIR)^\php.exe.res $(BUILD_DIR)^\php.exe.manifest  >> %X_MAKEFILE%



rem https://www.cnblogs.com/sherry-best/archive/2013/04/15/3022705.html
rem https://learn.microsoft.com/zh-CN/cpp/c-runtime-library/crt-library-features?view=msvc-170&viewFallbackFrom=vs-2019
rem echo 	^@"$(LINK)" ^/nologo  $(PHP_GLOBAL_OBJS) $(PHP_GLOBAL_OBJS_RESP) $(CLI_GLOBAL_OBJS) $(CLI_GLOBAL_OBJS_RESP)  $(STATIC_EXT_OBJS_RESP)  $(STATIC_EXT_OBJS)  $(ASM_OBJS) $(LIBS) $(LIBS_CLI) $(BUILD_DIR)^\php.exe.res /out:$(BUILD_DIR)^\php.exe $(LDFLAGS) $(LDFLAGS_CLI)    >> %x_makefile%
rem echo 	^@"$(LINK)" ^/nologo $(DEPS_CLI)  $(STATIC_EXT_OBJS_RESP)  $(STATIC_EXT_LIBS)  $(ASM_OBJS) $(LIBS) $(LIBS_CLI)    $(BUILD_DIR)^\php.exe.res  /out:$(BUILD_DIR)^\php.exe $(LDFLAGS) $(LDFLAGS_CLI)  >> %x_makefile%
rem echo 	-@$(_VC_MANIFEST_EMBED_EXE)   >> %x_makefile%
rem echo 	^@echo SAPI sapi\cli build complete  >> %x_makefile%
rem echo 	@if exist php.exe.manifest $(MT) -nologo -manifest php.exe.manifest -outputresource:php.exe    >> %x_makefile%

rem  /WHOLEARCHIVE  /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib /FORCE:MULTIPLE
rem libcpmt.lib  libvcruntime.lib libucrt.lib msvcrt.lib
rem  /NODEFAULTLIB:libc.lib /NODEFAULTLIB:libcmt.lib /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:libcd.lib /NODEFAULTLIB:libcmtd.lib /NODEFAULTLIB:msvcrtd.lib
rem libvcruntime.lib libcmt.lib

rem /MANIFEST:php.exe.manifest /MANIFESTUAC:uiAccess /SUBSYSTEM:CONSOLE  /subsystem:windows

:x-release-php-end



rem nmake /E x-release-php
:: nmake /E php.exe


:: nmake /E php.exe
nmake /E /f Makefile  x-release-php




:: .\x64\Release\php.exe -v
:: .\x64\Release\php.exe -m
:: dumpbin /DEPENDENTS ".\x64\Release\php.exe"
:: dumpbin /DEPENDENTS ".\x64\Release_TS\php.exe"


cd %__PROJECT__%
endlocal

