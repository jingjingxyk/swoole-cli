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

WORK_TEMP_DIR=${__PROJECT__}/var/msys2-build/
cd ${WORK_TEMP_DIR}/socat/
ldd ./socat

cd ${__PROJECT__}
APP_VERSION=$(echo -n $(cat ${__PROJECT__}/APP_VERSION))
APP_NAME=$(echo -n $(cat ${__PROJECT__}/APP_NAME))
NAME="${APP_NAME}-${APP_VERSION}-msys2-x64"

test -d /tmp/${NAME} && rm -rf /tmp/${NAME}
mkdir -p /tmp/${NAME}

cd ${WORK_TEMP_DIR}/socat/
ldd ./socat | grep -v '/c/Windows/' | awk '{print $3}'
ldd ./socat | grep -v '/c/Windows/' | awk '{print $3}' | xargs -I {} cp {} /tmp/${NAME}/

cp -f ./COPYING /tmp/${NAME}/
cp -f ./COPYING.OpenSSL /tmp/${NAME}/
cp -f ./socat /tmp/${NAME}/
cp -f ./cacert.pem /tmp/${NAME}/

cd /tmp/${NAME}/

zip -r ${__PROJECT__}/${NAME}.zip .

cd ${__PROJECT__}
