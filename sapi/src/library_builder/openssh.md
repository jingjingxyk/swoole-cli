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
