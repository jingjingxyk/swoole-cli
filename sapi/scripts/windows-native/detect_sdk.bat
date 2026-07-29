@echo off
:: chcp 65001 >nul
chcp 936 >nul
for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -legacy -property resolvedInstallationPath`) do (
  set VSinstallDir=%%i
)
echo Visual Studio 安装路径: %VSinstallDir%

set VSCMD_ARG_HOST_ARCH=x64
set VSCMD_ARG_TGT_ARCH=x64

call %VSinstallDir%\Common7\Tools\vsdevcmd\core\winsdk.bat

echo 默认 Windows SDK 版本: %WindowsSDKVersion%
echo Windows SDK 库版本: %WindowsSDKLibVersion%
