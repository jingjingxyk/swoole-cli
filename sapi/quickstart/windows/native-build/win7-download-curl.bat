@echo off

setlocal enableextensions enabledelayedexpansion


echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%

md %__PROJECT__%\var\windows-build-deps\

cd /d %__PROJECT__%\var\windows-build-deps\

where powershell

powershell -command "Write-Output (Get-Date)"
rem powershell -file path\to\your\script.ps1

if exist "curl-8.8.0_1-win64-mingw\curl-8.8.0_1-win64-mingw\bin\curl.exe" (
    echo The file exists.
) else (
    echo The file does not exist.
    powershell -command "Invoke-WebRequest -Uri https://curl.se/windows/dl-8.8.0_1/curl-8.8.0_1-win64-mingw.zip  -OutFile .\curl-8.8.0_1-win64-mingw.zip "
    rem powershell -command "Invoke-WebRequest -Uri https://www.7-zip.org/a/7z2409-x64.exe  -OutFile .\7z2409-x64.exe "

	rem .\7z2409-x64.exe /S
	rem set "PATH=%ProgramFiles%\7-Zip;%PATH%;"
	rem "C:\Program Files\7-Zip\7z.exe" x "%__PROJECT__%\var\windows-build-deps\curl-8.8.0_1-win64-mingw.zip" -o"%__PROJECT__%\var\windows-build-deps\curl-8.8.0_1-win64-mingw\"
)

if exist "curl-8.8.0_1-win64-mingw\curl-8.8.0_1-win64-mingw\bin\curl.exe" (
	powershell -command Remove-Item -Path "%__PROJECT__%\var\windows-build-deps\curl-8.8.0_1-win64-mingw" -Recurse
)

powershell -command Expand-Archive -Path 'curl-8.8.0_1-win64-mingw.zip' -DestinationPath 'curl-8.8.0_1-win64-mingw' -Force

set "PATH=%__PROJECT__%\var\windows-build-deps\curl-8.8.0_1-win64-mingw\curl-8.8.0_1-win64-mingw\bin;%PATH%"
dir %__PROJECT__%\var\windows-build-deps\curl-8.8.0_1-win64-mingw\curl-8.8.0_1-win64-mingw\bin
where curl.exe
curl.exe -V

rem C:\Windows\System32\curl.exe





endlocal
