<?php


error_reporting(E_ALL);
ini_set("display_errors", 1);

$http = new Swoole\Http\Server('127.0.0.1', 9501);

$document_root = __DIR__;

$http->set([
    //'document_root' => $document_root,
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

