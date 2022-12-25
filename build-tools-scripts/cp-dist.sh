#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)

cd ${__DIR__}
mkdir -p ${__DIR__}/dist/

test -f ${__PROJECT__}/bin/swoole-cli && cp -f ${__PROJECT__}/bin/swoole-cli ${__DIR__}/dist/

cd ${__DIR__}
chown -R 1000:1000 ${__DIR__}/
cat >dist/index.php<<EOF
<?php
phpinfo();
EOF


