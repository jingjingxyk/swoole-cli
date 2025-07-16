param(
    [string]
    $domain = ''
)
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

irm $url -outfile "$__PROJECT__\http-proxy.bat"

Invoke-Expression -Command "cmd /c $__PROJECT__\http-proxy.bat $domain"

exit

$text = Get-Content -Path http-proxy.bat;
if ($proxy -ne '')
{
    $newText = $text -replace "http-proxy.example.com", "$domain"

    # Write-Host $newText
    $newText | Out-File -FilePath "$__PROJECT__\http-proxy.bat" -Encoding ASCII
}


Invoke-Expression -Command "cmd /c $__PROJECT__\http-proxy.bat"

# & cmd /c $__PROJECT__\http-proxy.bat

# Start-Process -FilePath "$__PROJECT__\http-proxy.bat"


# powershell allow
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
