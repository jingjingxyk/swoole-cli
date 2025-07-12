# setup runtime

```bash

curl -fSLo cacert.pem https://curl.se/ca/cacert.pem

# coturn
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-coturn-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-coturn-runtime.sh | bash -s -- --mirror china

# socat
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-socat-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-socat-runtime.sh | bash -s -- --mirror china
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-socat-runtime.sh?raw=true | bash -s -- --version v2.2.1 --socat-version v1.8.0.1

# nginx
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-nginx-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nginx-runtime.sh | bash -s -- --mirror china

# php
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-php-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-php-runtime.sh | bash -s -- --mirror china

# php-cli
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-php-cli-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-php-cli-runtime.sh | bash -s -- --mirror china

# php-fpm
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-php-fpm-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-php-fpm-runtime.sh | bash -s -- --mirror china

# swoole
curl -fsSL  https://github.com/swoole/installers/blob/main/install.sh?raw=true | bash -s -- --mirror china --latest
curl -fsSL  https://gitee.com/jingjingxyk/swoole-install/raw/main/install.sh | bash -s -- --mirror china --latest

# swoole-cli
curl -fSL  https://swoole-cli.jingjingxyk.com/setup-swoole-cli-pre-runtime.sh | bash
curl -fSL  https://swoole-cli.jingjingxyk.com/setup-swoole-cli-pre-runtime.sh | bash -s -- --proxy socks5h://127.0.0.1:2000


# privoxy
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-privoxy-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-privoxy-runtime.sh | bash -s -- --mirror china

# brew
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/sapi/quickstart/macos/install-homebrew.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/macos/install-homebrew.sh | bash

# supervisor
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-supervisord.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-supervisord.sh | bash -s -- --mirror china

curl -fSL  https://kubernetes-tools.dengxiaci.com/proxy/supervisord-setup.sh | bash

# aria2
curl -fSL  https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-aria2-runtime.sh?raw=true | bash
curl -fSL  https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-aria2-runtime.sh | bash -s -- --mirror china


# iperf3
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-iperf3-runtime.sh?raw=true | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-iperf3-runtime.sh | bash -s -- --mirror china

# openssh
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-openssh-runtime.sh?raw=true | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-openssh-runtime.sh | bash -s -- --mirror china

# ttyd
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-ttyd-runtime.sh?raw=true | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-ttyd-runtime.sh | bash -s -- --mirror china

# install docker
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/sapi/quickstart/linux/install-docker.sh?raw=true | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/install-docker.sh | bash -s -- --mirror china

## http-proxy
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/sapi/quickstart/unix/http-proxy.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/unix/http-proxy.sh?raw=ture | bash

## nodejs
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-nodejs-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china

## python3
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-python3-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-python3-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-python3-runtime.sh?raw=ture | bash -s -- --mirror china

## sunshine
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-sunshine-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-sunshine-runtime.sh?raw=ture | bash

## moonlight
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-moonlight-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-moonlight-runtime.sh?raw=ture | bash

## 如意玲珑
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-linyaps-runtime.sh?raw=ture | bash
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-linyaps-runtime.sh?raw=ture | bash

## http proxy
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/sapi/quickstart/unix/http-proxy.sh | bash -s -- --domain http-proxy.example.com
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/unix/http-proxy.sh | bash -s -- --domain http-proxy.example.com

# ovs ovn
sed -i.bak 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
sed -i.bak 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
sed -i.bak 's/mirrors.ustc.edu.cn/deb.debian.org/g' /etc/apt/sources.list.d/debian.sources

apt update -y
apt install -y curl

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/SDN/install-ovn-ovs.sh | bash -s -- --mirror china --install-deps
curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/SDN/install-ovn-ovs.sh | bash -s --  --install-deps
curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/sapi/quickstart/linux/SDN/install-ovn-ovs.sh?raw=true | bash

curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/sapi/quickstart/linux/SDN/install-ovn-ovs.sh?raw=true | bash -s --  --install-deps

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/debian-init-minimal.sh

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/debian-init-minimal.sh | bash -s -- --mirror china

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/debian-init.sh | bash -s -- --mirror china

curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/sapi/quickstart/linux/SDN/install-ovn-ovs.sh | bash -s -- --proxy http://127.0.0.1:8016




```
