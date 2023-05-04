<?php

require __DIR__ . '/vendor/autoload.php';

use SwooleCli\Preprocessor;
use SwooleCli\Library;

$homeDir = getenv('HOME');
$p = Preprocessor::getInstance();
$p->parseArguments($argc, $argv);


// Compile directly on the host machine, not in the docker container
if ($p->getInputOption('without-docker')) {
    $p->setWorkDir(__DIR__);
    $p->setBuildDir(__DIR__ . '/thirdparty');
    $p->setGlobalPrefix($homeDir . '/.swoole-cli');
}


// Sync code from php-src
//重新设置 PHP 源码所在目录
$p->setPhpSrcDir($p->getWorkDir() . '/php-src');
//设置PHP 安装目录和版本号
$version = '8.2.4';
define("BUILD_PHP_VERSION", $version);
define("BUILD_PHP_INSTALL_PREFIX", $p->getWorkDir() . '/bin/php-' . $version);


$build_type = $p->getInputOption('with-build-type');
if (!in_array($build_type, ['dev', 'debug'])) {
    $build_type = 'release';
}
define('SWOOLE_CLI_BUILD_TYPE', $build_type);
define('SWOOLE_CLI_GLOBAL_PREFIX', $p->getGlobalPrefix());


if ($p->getOsType() == 'macos') {
    $p->setExtraLdflags('-undefined dynamic_lookup');
}

$p->setExtraCflags('-fno-ident -Os');


// Generate make.sh
$p->execute();

function install_libraries($p): void
{
    $php_install_prefix = BUILD_PHP_INSTALL_PREFIX;
    $php_src = $p->getPhpSrcDir();
    $build_dir = $p->getBuildDir();
    $p->addLibrary(
        (new Library('php_src'))
            ->withUrl('https://github.com/php/php-src/archive/refs/tags/php-' . BUILD_PHP_VERSION . '.tar.gz')
            ->withHomePage('https://www.php.net/')
            ->withLicense('https://github.com/php/php-src/blob/master/LICENSE', Library::LICENSE_PHP)
            ->withFile('php-7.3.33.tar.gz')
            ->withDownloadScript(
                'php-src',
                <<<EOF
                git clone -b php-7.3.33 --depth=1 https://github.com/php/php-src.git
EOF
            )
            ->withPrefix($php_install_prefix)
            ->withCleanBuildDirectory()
            ->withBuildScript(
                <<<EOF
                cd ..
                if test -d {$php_src} ; then
                    rm -rf {$php_src}
                fi
                cp -rf php_src {$php_src}
                cd {$build_dir}/php_src
EOF
            )
    );
}
