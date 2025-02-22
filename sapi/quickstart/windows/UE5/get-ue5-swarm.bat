setlocal

set "PATH=%ProgramFiles%\7-Zip;%PATH%;"

echo %~dp0
cd /d %~dp0


set "__PROJECT__=%cd%"
echo %cd%

set UE5_SWARM="%__PROJECT__%\ue5-swarm\"

rem Remove-Item -Path "C:\path\to\directory" -Recurse -Force

if exist "%UE5_SWARM%" (
	rmdir /s /q "%UE5_SWARM%"
)


md "%UE5_SWARM%"
dir
:: exit /b

:: cd [UE4ROOT]\Engine\Binaries\DotNET

:: swarm coordinator
rem AgentInterface.dll
rem SwarmCommonUtils.dll
rem SwarmCoordinator.exe
rem SwarmCoordinator.exe.config
rem SwarmCoordinatorInterface.dll
rem SwarmInterface.dll
rem UnrealControls.dll

copy .\AgentInterface.dll %UE5_SWARM%
copy .\SwarmCommonUtils.dll %UE5_SWARM%
copy .\SwarmCoordinator.exe %UE5_SWARM%
copy .\SwarmCoordinator.exe.config %UE5_SWARM%
copy .\SwarmCoordinatorInterface.dll %UE5_SWARM%
copy .\SwarmInterface.dll %UE5_SWARM%
copy .\UnrealControls.dll %UE5_SWARM%

:: swarm agent
rem SwarmAgent.exe
rem AgentInterface.dll
rem SwarmCommonUtils.dll
rem SwarmCoordinatorInterface.dll
rem SwarmInterface.dll
rem UnrealControls.dll

copy .\SwarmAgent.exe %UE5_SWARM%
copy .\AgentInterface.dll %UE5_SWARM%
copy .\SwarmCommonUtils.dll %UE5_SWARM%
copy .\SwarmCoordinatorInterface.dll %UE5_SWARM%
copy .\SwarmInterface.dll %UE5_SWARM%
copy .\UnrealControls.dll %UE5_SWARM%


cd /d %UE5_SWARM%

7z a "%__PROJECT__%\ue5-swarm.7z" *

endlocal
