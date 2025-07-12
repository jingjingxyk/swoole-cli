
设置 Fail2ban

https://docs.gitea.com/zh-cn/administration/fail2ban-setup

## 使用 fail2ban

    apt install -y fail2ban  sqlite3
    systemctl enable fail2ban
    systemctl status fail2ban
    systemctl start fail2ban
    journalctl -u ssh.service -f
    journalctl -u fail2ban.service

    tail -f /var/log/fail2ban.log


    vi /etc/fail2ban/jail.conf
    ignoreip = 127.0.0.0/8 10.0.0.0/8 100.64.0.0/10 172.16.0.0/12 192.168.0.0/16 ::1/128 fe80::/10 fd00::/8 ff00::/8

    vi /etc/fail2ban/jail.sshd.local
    [sshd]
    enabled = true
    port = ssh
    filter = sshd
    logpath = /var/log/auth.log
    maxretry = 3
    bantime = 3600
    findtime = 600

    # logpath = %(sshd_log)s
    # backend = %(sshd_backend)s

    backend = systemd
    journalmatch = _SYSTEMD_UNIT=sshd.service + _COMM=sshd

    systemctl restart fail2ban

    fail2ban-client set sshd banip 192.168.1.100
    fail2ban-client status
    fail2ban-client status sshd
    fail2ban-client get sshd ignoreip

    cat /var/log/fail2ban.log | grep "Ban"
    fail2ban-client status sshd | grep "Banned IP list"

    sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT name FROM sqlite_master WHERE type='table'"
    sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT * FROM fail2banDb"
    sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT * FROM logs"
    sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT * FROM bans"
    sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT * FROM bips"


    /usr/bin/fail2ban-server -xf start
