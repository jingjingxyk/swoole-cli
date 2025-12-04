setlocal


echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

md %__PROJECT__%\var\windows-build-deps\

cd /d %__PROJECT__%\var\windows-build-deps\


if not exist "strawberry-perl-5.38.2.2-64bit.msi" curl.exe -fSLo strawberry-perl-5.38.2.2-64bit.msi https://github.com/StrawberryPerl/Perl-Dist-Strawberry/releases/download/SP_53822_64bit/strawberry-perl-5.38.2.2-64bit.msi
if not exist "nasm-2.16.03-win64.zip" curl.exe -fSLo nasm-2.16.03-win64.zip https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/win64/nasm-2.16.03-win64.zip
if not exist "7z2409-x64.exe" curl.exe -fSLo 7z2409-x64.exe https://www.7-zip.org/a/7z2409-x64.exe

rem homepage
rem http://www.libarchive.org/
:: if not exist "libarchive-v3.7.4-amd64.zip" curl.exe -fSLo libarchive-3.8.1.tar.gz https://github.com/libarchive/libarchive/releases/download/v3.8.1/libarchive-3.8.1.tar.gz
:: if not exist "vcpkg" git clone https://github.com/Microsoft/vcpkg.git
:: .\vcpkg\bootstrap-vcpkg.bat
:: .\vcpkg\vcpkg.exe install libarchive



:: vs2019
:: curl -Lo VisualStudioSetup.exe 'https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2019'
:: curl -Lo VisualStudioSetup.exe 'https://aka.ms/vs/16/release/vs_community.exe'

:: vs2022
:: curl.exe -fSLo vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
:: curl -fSL VisualStudioSetup.exe 'https://aka.ms/vs/17/release/vs_community.exe'
if not exist "VisualStudioSetup.exe" curl.exe -fSLo VisualStudioSetup.exe "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2022"


if not exist "jq-windows-amd64.exe" curl.exe -fSLo jq-windows-amd64.exe https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-windows-amd64.exe

if not exist "TEMP_PHP_RUNTIME_FILE" curl.exe https://windows.php.net/downloads/releases/releases.json | jq-windows-amd64.exe ".[\"8.3\"].[\"nts-vs16-x64\"].[\"zip\"].[\"path\"]" -r > TEMP_PHP_RUNTIME_FILE

set /p PHP_RUNIME_FILE=<TEMP_PHP_RUNTIME_FILE
echo %PHP_RUNIME_FILE%

if not exist "php-nts-Win32-x64.zip" curl.exe -fSLo php-nts-Win32-x64.zip "https://windows.php.net/downloads/releases/%PHP_RUNIME_FILE%"
if not exist "composer.phar" curl.exe -fSLo composer.phar "https://getcomposer.org/download/latest-stable/composer.phar"
if not exist "cacert.pem" curl.exe -fSLo cacert.pem "https://curl.se/ca/cacert.pem"

if not exist "php-sdk-binary-tools" git clone -b master --depth=1 https://github.com/php/php-sdk-binary-tools.git
if not exist "php-src" git clone -b php-8.4.2 --depth=1 https://github.com/php/php-src.git php-src


:: with mirror
:: curl.exe -fSLo Git-2.47.1-64-bit.exe  https://download.jingjingxyk.com/Git-2.47.1-64-bit.exe
:: curl.exe -fSLo 7z2409-x64.exe  https://download.jingjingxyk.com/7z2409-x64.exe
:: curl.exe -fSLo nasm-2.16.03-win64.zip  https://download.jingjingxyk.com/nasm-2.16.03-win64.zip



endlocal
