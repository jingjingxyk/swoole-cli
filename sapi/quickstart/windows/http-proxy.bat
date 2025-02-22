@echo off

setlocal enableextensions
rem show current file location
echo %~dp0
cd /d %~dp0
if exist "..\..\..\prepare.php" (
   cd /d ..\..\..\
)
set "__PROJECT__=%cd%"

md %__PROJECT__%\var\
cd %__PROJECT__%\var\

if not exist "%__PROJECT__%\var\socat-v1.8.0.1-cygwin-x64.zip" (
	powershell  -NoProfile -NoLogo -command "Invoke-WebRequest -Uri https://php-cli.jingjingxyk.com/socat-v1.8.0.1-cygwin-x64.zip -OutFile socat-v1.8.0.1-cygwin-x64.zip"
	:: powershell  -NoProfile -NoLogo -command "irm https://php-cli.jingjingxyk.com/socat-v1.8.0.1-cygwin-x64.zip -outfile socat-v1.8.0.1-cygwin-x64.zip"
	powershell  -NoProfile -NoLogo -command "irm https://curl.se/ca/cacert.pem -outfile cacert.pem"
)
if not exist "%__PROJECT__%\var\socat-v1.8.0.1-cygwin-x64" (
	powershell -command "Expand-Archive -Path .\socat-v1.8.0.1-cygwin-x64.zip -DestinationPath .\socat-v1.8.0.1-cygwin-x64"
	copy cacert.pem %__PROJECT__%\var\socat-v1.8.0.1-cygwin-x64\socat-v1.8.0.1-cygwin-x64\
)

:: curl.exe -fSLo socat-v1.8.0.1-cygwin-x64.zip https://php-cli.jingjingxyk.com/socat-v1.8.0.1-cygwin-x64.zip
:: curl.exe -fSLo cacert.pem https://curl.se/ca/cacert.pem
:: 7z.exe x -osocat-v1.8.0.1-cygwin-x64 socat-v1.8.0.1-cygwin-x64.zip


cd %__PROJECT__%\var\socat-v1.8.0.1-cygwin-x64\socat-v1.8.0.1-cygwin-x64\

set "DOMAIN=http-proxy.xiaoshuogeng.com:8015"
set "SNI=http-proxy.xiaoshuogeng.com"

.\socat -d -d  TCP4-LISTEN:8016,reuseaddr,fork ssl:%DOMAIN%,snihost=%SNI%,commonname=%SNI%,openssl-min-proto-version=TLS1.3,openssl-max-proto-version=TLS1.3,verify=1,cafile=cacert.pem


:: with http_proxy

:: command set http_proxy
rem set http_proxy=http://127.0.0.1:8016
rem set https_proxy=http://127.0.0.1:8016

:: powershell set http_proxy
rem $Env:http_proxy="http://127.0.0.1:8016"
rem $Env:https_proxy="http://127.0.0.1:8016"



endlocal


