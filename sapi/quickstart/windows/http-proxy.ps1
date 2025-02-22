$__DIR__ = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host  $__DIR__
$__DIR__ = (Get-Location).Path
$__PROJECT__ = $__DIR__

Write-host $__DIR__
Write-Host (Get-Location).Path

cd $__DIR__
pwd

$url = "https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/windows/http-proxy.bat"
if (-not (Test-Path -Path http-proxy.bat))
{
    #    irm $url -outfile http-proxy.bat
}

irm $url -outfile http-proxy.bat
$text = Get-Content -Path http-proxy.bat;
$newText = $text -replace "apple", "orange"

# Write-Host $newText
$newText | Out-File -FilePath "$__PROJECT__\http-proxy.bat" -Encoding ASCII

Invoke-Expression -Command "cmd /c $__PROJECT__\http-proxy.bat"

# & cmd /c $__PROJECT__\http-proxy.bat

# Start-Process -FilePath "$__PROJECT__\http-proxy.bat"


