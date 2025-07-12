## 禁止密码登录

    vi /etc/ssh/sshd_config

    PasswordAuthentication no          # 禁用密码认证
    PermitRootLogin prohibit-password  # 禁止 root 密码登录（仅允许密钥）
    PubkeyAuthentication yes           # 使用密钥
    ChallengeResponseAuthentication no # 禁止交互式应答
    AllowUsers root                    # 允许登录的用户

    systemctl restart sshd
    journalctl -f
    journalctl -u ssh.service -f


    apt install -y fail2ban
    fail2ban-client set sshd banip 192.168.1.100
    fail2ban-client status
    fail2ban-client status sshd
    systemctl enable fail2ban


    systemctl restart fail2ban

    tail -f /var/log/fail2ban.log
    cp -f /etc/fail2ban/jail.conf /etc/fail2ban/jail.sshd.local
    vi /etc/fail2ban/jail.conf
    ignoreip = 127.0.0.0/8 10.0.0.0/8 100.64.0.0/10 172.16.0.0/12 192.168.0.0/16 ::1/128 fe80::/10 fd00::/8 ff00::/8

    fail2ban-client get sshd ignoreip

    vi /etc/fail2ban/jail.sshd.local
    [sshd]
    enabled = true
    port = ssh
    filter = sshd
    logpath = /var/log/auth.log
    maxretry = 3
    bantime = 3600
