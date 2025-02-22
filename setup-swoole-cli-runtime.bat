rem @echo off

setlocal enableextensions  enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
cd /d .
set "__PROJECT__=%cd%"

md %__PROJECT__%\var\runtime\

cd %__PROJECT__%\var\runtime\


set "VERSION=v6.0.0.0"
set "APP_VERSION=v6.0.0"
set "APP_RUNTIME=swoole-cli-%APP_VERSION%-cygwin-x64"
set "APP=%APP_RUNTIME%.zip"


set "APP_DOWNLOAD_URL=https://github.com/swoole/swoole-cli/releases/download/%VERSION%/%APP_RUNTIME%.zip"
set "COMPOSER_DOWNLOAD_URL=https://getcomposer.org/download/latest-stable/composer.phar"
set "CACERT_DOWNLOAD_URL=https://curl.se/ca/cacert.pem"


:getopt
if /i "%1" equ "--mirror" (
	if /i "%2" equ "china" (
		set "APP_DOWNLOAD_URL=https://wenda-1252906962.file.myqcloud.com/dist/%APP_RUNTIME%.zip"
		set "COMPOSER_DOWNLOAD_URL=https://mirrors.tencent.com/composer/composer.phar"
	)
)
shift

if not (%1)==() goto getopt


if not exist "%APP_RUNTIME%.zip" curl.exe -fSLo %APP_RUNTIME%.zip %APP_DOWNLOAD_URL%
if not exist "composer.phar" curl.exe -fSLo composer.phar %COMPOSER_DOWNLOAD_URL%
if not exist "cacert.pem" curl.exe -fSLo cacert.pem %CACERT_DOWNLOAD_URL%


if not exist "%APP_RUNTIME%" (
	powershell -command "Expand-Archive -Path .\%APP_RUNTIME%.zip -DestinationPath .\%APP_RUNTIME%"
	copy cacert.pem .\%APP_RUNTIME%"
)

set "original_string=%__PROJECT__%"
set "string_to_find=\"
set "string_to_replace=/"
set modified_string=!original_string:%string_to_find%=%string_to_replace%!

set "original_string=%modified_string%"
set "string_to_find=:"
set "string_to_replace="
set modified_string=!original_string:%string_to_find%=%string_to_replace%!

set "UNIX_PROJECT=/cygdrive/%modified_string%"
set "PHP_INI=%UNIX_PROJECT%/var/runtime/php.ini"



(

	echo curl.cainfo=%UNIX_PROJECT%/var/runtime/%APP_RUNTIME%/cacert.pem
	echo openssl.cafile=%UNIX_PROJECT%/var/runtime/%APP_RUNTIME%/cacert.pem
	echo swoole.use_shortname=off
	echo display_errors = On
	echo error_reporting = E_ALL

	echo upload_max_filesize=128M
	echo post_max_size=128M
	echo memory_limit=1G
	echo date.timezone=UTC

	echo opcache.enable=On
	echo opcache.enable_cli=On
	echo opcache.jit=1225
	echo opcache.jit_buffer_size=128M

	echo expose_php=Off
	echo apc.enable_cli=1

) > php.ini

echo %PHP_INI%
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -h
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% -v
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% -m
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% --ri curl
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% --ri openssl
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% --ri swoole
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% %UNIX_PROJECT%/var/runtime/composer.phar list

cd %__PROJECT__%

set COMPOSER_IGNORE_PLATFORM_REQ=hhvm
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% %UNIX_PROJECT%/var/runtime/composer.phar config -g repos.packagist composer https://mirrors.tencent.com/composer/
%__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% %UNIX_PROJECT%/var/runtime/composer.phar update  -vvv --prefer-install=dist  --ignore-platform-req=php

:: %__PROJECT__%\var\runtime\%APP_RUNTIME%\%APP_RUNTIME%\bin\swoole-cli.exe -c %PHP_INI% %UNIX_PROJECT%/var/runtime/composer.phar config -g repos.packagist composer https://packagist.org

endlocal
