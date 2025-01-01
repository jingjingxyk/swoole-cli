

install gitea with docker

https://docs.gitea.com/zh-cn/installation/install-with-docker



k8s 使用的端口

https://kubernetes.io/zh-cn/docs/reference/networking/ports-and-protocols/

不带选择器的服务
Services without selectors
https://kubernetes.io/docs/concepts/services-networking/service/#services-without-selectors



从主机到容器的 SSH 转发

```shell

sudo -u git ssh-keygen -t rsa -b 4096 -C "Gitea Host Key"


ssh -p 2222 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"



```

设置 Fail2ban
https://docs.gitea.com/zh-cn/administration/fail2ban-setup
