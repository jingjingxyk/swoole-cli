setlocal


echo %~dp0
cd /d %~dp0
cd /d ..\..\..\..\

set "__PROJECT__=%cd%"
echo %cd%


curl.exe -fSLo EpicGamesLauncherInstaller.msi https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi?productName=unrealEngine


endlocal
