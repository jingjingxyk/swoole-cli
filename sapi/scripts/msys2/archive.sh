#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../
  pwd
)
cd ${__PROJECT__}

cd ${__PROJECT__}/
ldd /usr/local/swoole-cli/openssh/sbin/sshd.exe
ldd /usr/local/swoole-cli/openssh/bin/ssh.exe
ldd /usr/local/swoole-cli/openssh/libexec/sftp-server.exe

cd ${__PROJECT__}
APP_VERSION=$(/usr/local/swoole-cli/openssh/sbin/sshd.exe -V 2>&1 | awk -F ',' '{ print $1 }' | awk -F '_' '{ print $2 }')
NAME="openssh-${APP_VERSION}-msys2-x64"
echo $APP_VERSION >${__PROJECT__}/APP_VERSION

test -d /tmp/${NAME} && rm -rf /tmp/${NAME}
mkdir -p /tmp/${NAME}/sbin/
mkdir -p /tmp/${NAME}/bin/
mkdir -p /tmp/${NAME}/libexec/

cd ${__PROJECT__}/
ldd /usr/local/swoole-cli/openssh/sbin/sshd.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/sbin/

ldd /usr/local/swoole-cli/openssh/bin/scp.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/
ldd /usr/local/swoole-cli/openssh/bin/ssh-add.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/
ldd /usr/local/swoole-cli/openssh/bin/ssh-keygen.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/
ldd /usr/local/swoole-cli/openssh/bin/ssh.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/
ldd /usr/local/swoole-cli/openssh/bin/sftp.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/
ldd /usr/local/swoole-cli/openssh/bin/ssh-agent.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/
ldd /usr/local/swoole-cli/openssh/bin/ssh-keyscan.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/bin/

ldd /usr/local/swoole-cli/openssh/libexec/ssh-keysign.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/libexec/
ldd /usr/local/swoole-cli/openssh/libexec/ssh-sk-helper.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/libexec/
ldd /usr/local/swoole-cli/openssh/libexec/sftp-server.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/libexec/
ldd /usr/local/swoole-cli/openssh/libexec/ssh-pkcs11-helper.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/libexec/
ldd /usr/local/swoole-cli/openssh/libexec/sshd-session.exe | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp -f {} /tmp/${NAME}/libexec/

ls -lh /tmp/${NAME}/

cp -rf /usr/local/swoole-cli/openssh/* /tmp/${NAME}/

cd /tmp/${NAME}/

test -f ${__PROJECT__}/${NAME}.zip && rm -f ${__PROJECT__}/${NAME}.zip
zip -r ${__PROJECT__}/${NAME}.zip .

cd ${__PROJECT__}
