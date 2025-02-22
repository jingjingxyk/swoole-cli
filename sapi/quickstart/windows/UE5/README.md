```shell
# windows
curl.exe -fSLo EpicGamesLauncherInstaller.msi https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi?productName=unrealEngine

# macos intel
curl -fSLo EpicGamesLauncher.dmg https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher.dmg?productName=unrealEngine

```

[Unreal Swarm](https://dev.epicgames.com/documentation/zh-cn/unreal-engine/unreal-swarm-in-unreal-engine)

```shell


.\EpicGamesLauncherInstaller.msi


```

```shell

# .NET Framework 3.5
# https://dotnet.microsoft.com/zh-cn/download/dotnet-framework/net35-sp1?wt.mc_id=install-docs

curl.exe -fSLo dotnetfx35.exe https://download.visualstudio.microsoft.com/download/pr/b635098a-2d1d-4142-bef6-d237545123cb/2651b87007440a15209cac29634a4e45/dotnetfx35.exe





```

## 命令行安装 visulstudio 增加 .net framework 3.5 组件

```shell

.\VisualStudioSetup.exe ^
modify ^
--locale en-US ^
--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
--add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 ^
--add Microsoft.VisualStudio.Component.VC.CMake.Project ^
--add Microsoft.VisualStudio.Component.Roslyn.Compiler ^
--add Microsoft.VisualStudio.Component.CoreBuildTools ^
--add Microsoft.VisualStudio.Component.Windows10SDK.20348	^
--add Microsoft.VisualStudio.Component.Windows10SDK ^
--add Microsoft.VisualStudio.Component.Windows11SDK.22000   ^
--add Microsoft.Component.VC.Runtime.UCRTSDK	^
--add Microsoft.Component.MSBuild ^
--add Microsoft.VisualStudio.Workload.MSBuildTools ^
--add Microsoft.VisualStudio.Workload.NativeDesktop ^
--path install="c:\vs" --path cache="c:\vs-cached" ^
--add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Component.NetFramework.3.5  ^
--add Microsoft.VisualStudio.Workload.VisualStudioExtension --includeRecommended  ^
--add Microsoft.VisualStudio.Component.VC.Tools.X64 --add Microsoft.VisualStudio.Component.VC.Tools.X86  ^
--add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Game --includeRecommended --quiet


```
