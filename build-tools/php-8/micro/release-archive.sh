#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}



php -c php-env.ini build-phar.php

cp -f ${__DIR__}/../build/php-src/sapi/micro/micro.sfx .

# cat micro.sfx release.phar > app
cat micro.sfx index.phar > app
chmod a+x app
cd ${__DIR__}/
chown -R 1000:1000 .