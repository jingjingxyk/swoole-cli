@echo off

:: cygwin site: https://cygwin.com/
:: start https://cygwin.com/setup-x86_64.exe
:: search package https://cygwin.com/cgi-bin2/package-grep.cgi

setlocal enableextensions enabledelayedexpansion

echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
cd /d %__PROJECT__%\
echo %cd%



set "SITE=https://mirrors.kernel.org/sourceware/cygwin/"

:getopt
if /i "%1" equ "--mirror" (
	if /i "%2" equ "china" (
		set "SITE=https://mirrors.ustc.edu.cn/cygwin/"
	)
)
shift

if not (%1)==() goto getopt

set "OPTIONS= --quiet-mode --disable-buggy-antivirus --site  %SITE%  "
set "PACKAGES="

if defined GITHUB_ACTIONS (
	set "OPTIONS= %OPTIONS% --no-desktop --no-shortcuts --no-startmenu  "
)

:: package  separate with commas
set "PACKAGES="
set "PACKAGES=%PACKAGES%,libiconv-devel"
set "PACKAGES=%PACKAGES%,libiconv"
set "PACKAGES=%PACKAGES%,libcharset1"
set "PACKAGES=%PACKAGES%,libiconv2"


set "OPTIONS=%OPTIONS% --packages %PACKAGES%"
echo %OPTIONS%

start /b /wait setup-x86_64.exe  %OPTIONS%

endlocal
