# 设置执行策略以允许脚本运行
# Set-ExecutionPolicy Bypass -Scope Process -Force
cmd /c ver
write-host $psversiontable.psversion

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd

Set-Service -Name sshd -StartupType Automatic

Get-Service sshd

try{
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} catch {
    Write-Error "An error occurred: $_"
}

# New-Item -Path "~\.ssh\" -ItemType Directory -Force
New-Item -Path "$env:USERPROFILE\.ssh\" -ItemType Directory -Force

Set-Content -Path "$env:USERPROFILE\.ssh\authorized_keys" -Value ""

Add-Content -Path "$env:USERPROFILE\.ssh\authorized_keys" -Value "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICl2QAvQ5YF2b6omciFh98UNsFyHlpfgrtkuom2Gsih+ Windows-SSH-Key"

$sshd_config_file ="$env:ProgramData\ssh\sshd_config"
$sshd_config_back_file ="$env:ProgramData\ssh\sshd_config.bak"

# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "PubkeyAuthentication yes"
# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "PasswordAuthentication no"
# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "PermitRootLogin yes"
# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "AcceptEnv PROMPT"
# Add-Content -Path "$env:ProgramData\ssh\sshd_config" -Value "Shell C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -NoLogo -NoProfile"

#$sshd_config = Get-Content -Path "$env:ProgramData\ssh\sshd_config"
# 备份sshd_config
if (-not (Test-Path -Path $sshd_config_back_file )) {
    cp $sshd_config_file $sshd_config_back_file
    # Copy-Item -Path $sshd_config_file -Destination $sshd_config_back_file

}
$new_sshd_config = @"
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Port 22
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::


# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

# For this to work you will also need host keys in %programData%/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
#PermitEmptyPasswords no

# GSSAPI options
#GSSAPIAuthentication no

AllowAgentForwarding yes
AllowTcpForwarding yes
GatewayPorts yes
#PermitTTY  yes
#PrintMotd yes
#PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
#PermitUserEnvironment no
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	sftp-server.exe

AllowGroups administrators "openssh users"

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server

#Match Group administrators
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

# AcceptEnv PROMPT
# Shell C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -NoLogo -NoProfile

"@

Set-Content -Path "$env:ProgramData\ssh\sshd_config"  -Value $new_sshd_config

# 设置默认终端为 powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

Restart-Service sshd
Get-Service sshd
netstat -ano | findstr ":22"
Get-NetFirewallRule -Name *OpenSSH-Server* |select Name, DisplayName, Description, Enabled



<#

md  ~\.ssh\
mkdir  ~\.ssh\

# echo.命令用来输出一个空行

echo. >  ~\.ssh\authorized_keys

## 配置所在目录
C:\ProgramData\ssh

# %programdata%\ssh\sshd_config

notepad $env:ProgramData\ssh\sshd_config

Get-Content $env:ProgramData\ssh\sshd_config

# ProgramData‌是Windows系统中的一个系统文件夹 ProgramData文件夹是隐藏的，默认情况下不会在文件资源管理器中显示

# 禁止密码登录（配置sshd_config)
PasswordAuthentication no
PermitRootLogin no
ChallengeResponseAuthentication no

# 使用密钥认证
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

#注释掉默认授权文件位置，确保以下条目被注释
#Match Group administrators
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

# 重启 sshd
Restart-Service sshd

# 添加密钥
ssh-add %USERPROFILE%\.ssh\id_rsa

cmd /c set "PATH=%PATH%;C:\Program Files\Git\bin\;"

$env:PATH += ";C:\Program Files\Git\bin;"

# 快速编辑 sshd_config
start-process notepad C:\Programdata\ssh\sshd_config

#>
