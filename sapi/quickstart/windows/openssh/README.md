# windows 启用 openssh sftp

## win10 以下版本，需要老版本的 openssh

```shell

rem openssh

:: https://github.com/PowerShell/Win32-OpenSSH.git
:: https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.8.1.0p1-Preview/OpenSSH-Win64.zip
cd Win32-OpenSSH
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1





```

```shell

powershell.exe -ExecutionPolicy Bypass -File enable-openssh.ps1

```

## 一行命令启动windows openssh

```shell

irm https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/windows/openssh/enable-openssh.ps1 | iex

```
