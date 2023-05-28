#!/usr/bin/env php
<?php
require __DIR__ . '/vendor/autoload.php';

use SwooleCli\Preprocessor;

const BUILD_PHP_VERSION = '8.1.12';

$homeDir = getenv('HOME');
$p = Preprocessor::getInstance();
$p->parseArguments($argc, $argv);


// Sync code from php-src
$p->setPhpSrcDir($homeDir . '/.phpbrew/build/php-' . BUILD_PHP_VERSION);

// Compile directly on the host machine, not in the docker container
if ($p->getInputOption('without-docker') || ($p->getOsType() == 'macos')) {
    $p->setWorkDir(__DIR__);
    $p->setBuildDir(__DIR__ . '/thirdparty');
}

$build_type = $p->getInputOption('with-build-type');
if (!in_array($build_type, ['dev', 'debug'])) {
    $build_type = 'release';
}
define('SWOLLEN_CLI_BUILD_TYPE', $build_type);
define('SWOOLE_CLI_GLOBAL_PREFIX', $p->getGlobalPrefix());


if ($p->getInputOption('with-global-prefix')) {
    $p->setGlobalPrefix($p->getInputOption('with-global-prefix'));
}

if ($p->getOsType() == 'macos') {
    $p->setExtraLdflags('-undefined dynamic_lookup');
    if (is_file('/usr/local/opt/llvm/bin/ld64.lld')) {
        $p->withPath('/usr/local/opt/llvm/bin')->setLinker('ld64.lld');
    }
}

$p->setExtraCflags('-fno-ident -Os');

// Generate make.sh
$p->execute();
