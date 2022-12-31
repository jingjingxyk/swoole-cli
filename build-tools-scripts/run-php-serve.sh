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

cd ${__DIR__}/dist/

cat >index.php<<EOF
<?php
phpinfo();
EOF
cat >serve.php<<'EOF'
<?php

$http = new Swoole\Http\Server('127.0.0.1', 9501);

$document_root = __DIR__;

$http->set([
    'document_root' => $document_root,
    'enable_static_handler' => true,
    'http_autoindex' => true,
    'http_index_files' => ['index', 'index.txt'],
]);

$http->on('start', function ($server) {
    echo "Swoole http server is started at http://127.0.0.1:9501\n";
});

$http->on('request', function ($request, $response) {
    $response->header('Content-Type', 'text/plain');
    ob_start();
    phpinfo();
    $content=ob_get_contents();
    ob_end_clean();
    $response->end($content);
});

$http->start();

EOF


xdg-open http://127.0.0.1:8032

#test -f ./swoole-cli && chmod a+x ./swoole-cli && ./swoole-cli ./serve.php
test -f ./swoole-cli && test -x ./swoole-cli || chmod a+x ./swoole-cli  ;
test -f ./swoole-cli &&  ./swoole-cli -S 0.0.0.0:8032 -t .

