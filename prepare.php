<?php

require __DIR__ . '/vendor/autoload.php';

use SwooleCli\Preprocessor;
use SwooleCli\Library;

$homeDir = getenv('HOME');
$p = Preprocessor::getInstance();
$p->parseArguments($argc, $argv);

# PHP 默认版本
$version = '7.3.33';

if ($p->getInputOption('with-php-version')) {
    $subject = $p->getInputOption('with-php-version');
    $pattern = '/(\d{1,2})\.\d{1,2}\.\d{1,2}/';
    $notice=0;
    if (preg_match($pattern, $subject, $match)) {
        if (intval($match[1]) == 7) {
            $version = $match[0];
        } else {
            $notice = 1;
        }
    } else {
        $notice = 1;
    }
    if ($notice == 1) {
        echo '此分支只支持 7.3 系列版本';
        echo PHP_EOL;
        if (is_file(__DIR__ . '/' . 'make.sh')) {
            unlink(__DIR__ . '/' . 'make.sh');
        }
        die;
    }
}

define('BUILD_PHP_VERSION', $version);

// Compile directly on the host machine, not in the docker container
if ($p->getInputOption('without-docker') || ($p->getOsType() == 'macos')) {
    $p->setWorkDir(__DIR__);
    $p->setBuildDir(__DIR__ . '/thirdparty');
}

$p->setRootDir(__DIR__);

// Sync code from php-src
//设置 PHP 源码所在目录
$p->setPhpSrcDir($p->getRootDir() . '/php-src');

//设置PHP 安装目录
define("BUILD_PHP_INSTALL_PREFIX", $p->getRootDir() . '/bin/php-' . BUILD_PHP_VERSION);

if ($p->getInputOption('with-global-prefix')) {
    $p->setGlobalPrefix($p->getInputOption('with-global-prefix'));
}

$buildType = $p->getBuildType();

if ($p->getInputOption('with-build-type')) {
    $buildType = $p->getInputOption('with-build-type');
    $p->setBuildType($buildType);
}

define('PHP_CLI_BUILD_TYPE', $buildType);
define('PHP_CLI_GLOBAL_PREFIX', $p->getGlobalPrefix());

if ($p->getInputOption('with-parallel-jobs')) {
    $p->setMaxJob(intval($p->getInputOption('with-parallel-jobs')));
}

$buildType = $p->getBuildType();
if ($p->getInputOption('with-build-type')) {
    $buildType = $p->getInputOption('with-build-type');
    $p->setBuildType($buildType);
}
define('SWOOLE_CLI_BUILD_TYPE', $buildType);
define('SWOOLE_CLI_GLOBAL_PREFIX', $p->getGlobalPrefix());

if ($p->getInputOption('with-http-proxy')) {
    $http_proxy = $p->getInputOption('with-http-proxy');
    define('PHP_CLI_HTTP_PROXY_URL', $http_proxy);
    $proxyConfig = <<<EOF
export HTTP_PROXY={$http_proxy}
export HTTPS_PROXY={$http_proxy}
export NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,198.18.0.0/15,169.254.0.0/16"
export NO_PROXY="\${NO_PROXY},127.0.0.1,localhost"
export NO_PROXY="\${NO_PROXY},.aliyuncs.com,.aliyun.com"
export NO_PROXY="\${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"

EOF;
    $p->setProxyConfig($proxyConfig);
}
if ($p->getInputOption('with-install-library-cached')) {
    $p->setInstallLibraryCached(true);
}

if ($p->getOsType() == 'macos') {
    $p->setExtraLdflags('-undefined dynamic_lookup');
    $p->setLinker('ld');
    if (is_file('/usr/local/opt/llvm/bin/ld64.lld')) {
        $p->withBinPath('/usr/local/opt/llvm/bin')->setLinker('ld64.lld');
    }
    $p->setLogicalProcessors('$(sysctl -n hw.ncpu)');
} else {
    $p->setLinker('ld.lld');
    $p->setLogicalProcessors('$(nproc 2> /dev/null)');
}

putenv('SWOOLE_CLI_WITH_C_COMPILER=gcc');
if ($p->getInputOption('with-c-compiler')) {
    $c_compiler = $p->getInputOption('with-c-compiler');
    if ($c_compiler == 'gcc') {
        $p->set_C_COMPILER('gcc');
        $p->set_CXX_COMPILER('g++');
        $p->setLinker('ld');
    }
}

$p->setExtraCflags('-Os');


// Generate make.sh
$p->execute();


function install_libraries(Preprocessor $p): void
{
    $p->loadDependentLibrary('php_src');
}
