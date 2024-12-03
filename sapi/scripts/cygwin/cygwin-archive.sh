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

cd ${__PROJECT__}/socat/
ldd ./socat

cd ${__PROJECT__}
SOCAT_VERSION=$(echo -n $(cat ./socat.version))
NAME="socat-v${SOCAT_VERSION}-cygwin-x64"

test -d /tmp/${NAME} && rm -rf /tmp/${NAME}
mkdir -p /tmp/${NAME}

cd ${__PROJECT__}/socat/
ldd ./socat | grep -v '/cygdrive/' | awk '{print $3}' | xargs -I {} cp {} /tmp/${NAME}/

cp -f ./COPYING /tmp/${NAME}/
cp -f ./COPYING.OpenSSL /tmp/${NAME}/
cp -f ./socat /tmp/${NAME}/

cd /tmp/

zip -r ${NAME}.zip ${NAME}

mv ${NAME}.zip ${__PROJECT__}/

cd ${__PROJECT__}
