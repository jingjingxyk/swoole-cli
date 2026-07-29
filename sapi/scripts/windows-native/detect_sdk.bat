@echo off
:: chcp 65001 >nul
:: chcp 936 >nul
for /f "usebackq tokens=*" %%i in (`vswhere.exe -latest -legacy -property resolvedInstallationPath`) do (
  set VSinstallDir=%%i
)
echo Visual Studio installDir: "%VSinstallDir%"

set VSCMD_ARG_HOST_ARCH=x64
set VSCMD_ARG_TGT_ARCH=x64

call "%VSinstallDir%\Common7\Tools\vsdevcmd\core\winsdk.bat"

echo default Windows SDK version: %WindowsSDKVersion%
echo Windows SDK library version: %WindowsSDKLibVersion%
