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

cd ${__DIR__}/dist/



# test -f php && rm -rf php
# curl -LO https://control-plane-endpoint.jingjingxyk.com/php-cli/php


./php -m > exts.txt
cat > index.php <<'EOF'
<?php

error_reporting(E_ALL);
ini_set("display_errors", 1);

echo "<xmp>";

echo file_get_contents('exts.txt');

echo "</xmp>";
phpinfo();

EOF

xdg-open http://127.0.0.1:8031
# gnome-terminal --window
# gnome-terminal -x 或者 xterm start
./php -S 0.0.0.0:8031  -t .
