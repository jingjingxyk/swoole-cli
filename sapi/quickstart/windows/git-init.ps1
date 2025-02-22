$__DIR__ = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host  $__DIR__
$__DIR__ = (Get-Location).Path
$__PROJECT__ = $__DIR__

Write-host $__DIR__
Write-Host (Get-Location).Path

cd $__DIR__
pwd


$url = "https://php-cli.jingjingxyk.com/Git-2.47.1-64-bit.exe"
$git_install_package = 'Git-2.47.1-64-bit.exe'
# 已经下载跳过
if (-not (Test-Path -Path $git_install_package))
{
    irm $url -outfile $git_install_package
}

# 已经安装 跳过
if (-not (Test-Path -Path "C:\Program Files\Git\bin\git.exe"))
{
    & cmd /c start /wait .\Git-2.47.1-64-bit.exe /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEONEXIT=1 /DIR="C:\Program Files\Git"
}

$env:PATH += ";C:\Program Files\Git\bin;"

# $env:PATH += ";${env:ProgramFiles}\Git\bin;${env:ProgramFiles}\7-Zip\;"

& cmd /c "git config --global core.autocrlf false"
& cmd /c "git config --global core.eol lf"
& cmd /c "git config --global core.ignorecase false"
& cmd /c "git config --global core.longpaths true"
& cmd /c "git config --list  "



