#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../
  pwd
)

cd ${__DIR__}



mkdir -p ${__DIR__}/dist/

test -f /tmp/php/bin/php && cp -f /tmp/php/bin/php   ${__DIR__}/dist/
test -f /tmp/php/bin/php-config && cp -f /tmp/php/bin/php-config   ${__DIR__}/dist/

cd ${__DIR__}
chown -R 1000:1000 ${__DIR__}/dist/
cat >dist/index.php<<EOF
<?php
phpinfo();
EOF


