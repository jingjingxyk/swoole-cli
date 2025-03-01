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

WORK_TEMP_DIR=${__PROJECT__}/var/cygwin-build/
cd ${WORK_TEMP_DIR}/privoxy/

APP_VERSION=$(/usr/local/swoole-cli/privoxy/sbin/privoxy.exe --help | grep 'Privoxy version' | awk '{print $3}')
NAME="privoxy-${APP_VERSION}-cygwin-x64"
echo ${APP_VERSION} >${__PROJECT__}/APP_VERSION

test -d /tmp/${NAME} && rm -rf /tmp/${NAME}
mkdir -p /tmp/${NAME}/sbin/

cd ${__PROJECT__}/
ldd /usr/local/swoole-cli/privoxy/sbin/privoxy.exe | grep -v '/cygdrive/' | awk '{print $3}'
ldd /usr/local/swoole-cli/privoxy/sbin/privoxy.exe | grep -v '/cygdrive/' | awk '{print $3}' | xargs -I {} cp {} /tmp/${NAME}/sbin/

ls -lh /tmp/${NAME}/

cp -rf /usr/local/swoole-cli/privoxy/* /tmp/${NAME}/

cd /tmp/${NAME}/

test -f ${__PROJECT__}/${NAME}.zip && rm -f ${__PROJECT__}/${NAME}.zip
zip -r ${__PROJECT__}/${NAME}.zip .

cd ${__PROJECT__}
