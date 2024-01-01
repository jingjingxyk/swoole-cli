<?php


declare(strict_types=1);


$content = file_get_contents(__DIR__ . '/main/php_version.h');
if (preg_match('/\d{1,}\.\d{1,}\.\d{1,}\w*/', $content, $match)) {
    var_dump($match);
    define("BUILD_PHP_VERSION", $match[0]);
} else {
    define("BUILD_PHP_VERSION", '8.1.12');
}
