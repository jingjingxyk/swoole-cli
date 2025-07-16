@echo off
echo all parameter：%*

set X_DOMAIN="%1"



setlocal enableextensions enabledelayedexpansion
rem show current file location
echo %~dp0
cd /d %~dp0
if exist "..\..\..\prepare.php" (
   cd /d ..\..\..\
)
set "__PROJECT__=%cd%"

md %__PROJECT__%\var\
cd %__PROJECT__%\var\

if not exist "%__PROJECT__%\var\socat-1.8.0.3-cygwin-x64.zip" (
	powershell  -NoProfile -NoLogo -command "Invoke-WebRequest -Uri https://php-cli.jingjingxyk.com/socat-1.8.0.3-cygwin-x64.zip -OutFile socat-1.8.0.3-cygwin-x64.zip"
	:: powershell  -NoProfile -NoLogo -command "irm https://php-cli.jingjingxyk.com/socat-1.8.0.3-cygwin-x64.zip -outfile socat-1.8.0.3-cygwin-x64.zip"
	:: powershell  -NoProfile -NoLogo -command "irm https://curl.se/ca/cacert.pem -outfile cacert.pem"
)
if not exist "%__PROJECT__%\var\socat-1.8.0.3-cygwin-x64" (
	powershell -command "Expand-Archive -Path .\socat-1.8.0.3-cygwin-x64.zip -DestinationPath .\socat-1.8.0.3-cygwin-x64"
	copy cacert.pem %__PROJECT__%\var\socat-1.8.0.3-cygwin-x64\socat-1.8.0.3-cygwin-x64\
)

:: curl.exe -fSLo socat-1.8.0.3-cygwin-x64 https://php-cli.jingjingxyk.com/socat-1.8.0.3-cygwin-x64.zip
:: curl.exe -fSLo cacert.pem https://curl.se/ca/cacert.pem
:: 7z.exe x -osocat-1.8.0.3-cygwin-x64 socat-1.8.0.3-cygwin-x64.zip


cd %__PROJECT__%\var\socat-1.8.0.3-cygwin-x64\

set "DOMAIN=http-proxy.example.com:8015"
set "SNI=http-proxy.example.com"
if defined X_DOMAIN (
    if not "!input!"=="" (
        echo "input domain ok"
        set "DOMAIN=%X_DOMAIN%:8015"
        set "SNI=%X_DOMAIN%"
    ) else (
        echo "input is null"
    )
) else (
    echo "var no define"
)

.\socat -d -d  TCP4-LISTEN:8016,reuseaddr,fork ssl:%DOMAIN%,snihost=%SNI%,commonname=%SNI%,openssl-min-proto-version=TLS1.3,openssl-max-proto-version=TLS1.3,verify=1,cafile=cacert.pem


:: with http_proxy

:: command set http_proxy
rem set http_proxy=http://127.0.0.1:8016
rem set https_proxy=http://127.0.0.1:8016

:: powershell set http_proxy
rem $Env:http_proxy="http://127.0.0.1:8016"
rem $Env:https_proxy="http://127.0.0.1:8016"



endlocal


