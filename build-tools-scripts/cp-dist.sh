#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__ROOT__=$(
  cd ${__DIR__}/../
  pwd
)


cd ${__DIR__}
mkdir -p ${__DIR__}/dist/

test -f /tmp/php/bin/php && cp -f /tmp/php/bin/php   ${__DIR__}/dist/
test -f /tmp/php/bin/php-config && cp -f /tmp/php/bin/php-config   ${__DIR__}/dist/
test -f ${__ROOT__}/bin/swoole-cli && cp -f ${__ROOT__}/bin/swoole-cli ${__DIR__}/dist/


chown -R 1000:1000 ${__ROOT__}/
cat >dist/index.php<<EOF
<?php
phpinfo();
EOF

pecl config-show
