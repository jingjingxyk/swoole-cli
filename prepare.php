<?php

require __DIR__ . '/vendor/autoload.php';

use SwooleCli\Preprocessor;
use SwooleCli\Library;



$homeDir = getenv('HOME');
$p = Preprocessor::getInstance();
$p->parseArguments($argc, $argv);

# clean old make.sh
if (file_exists(__DIR__ . '/make.sh')) {
    unlink(__DIR__ . '/make.sh');
    unlink(__DIR__ . '/make-install-deps.sh');
    unlink(__DIR__ . '/make-env.sh');
    unlink(__DIR__ . '/make-export-variables.sh');
}

if (file_exists(__DIR__ . '/make-download-box.sh')) {
    unlink(__DIR__ . '/make-download-box.sh');
}

# PHP 默认版本
$php_version = '8.2.11';
$php_version_id = '802011';
$php_version_tag = 'php-8.2.11';

if ($p->getInputOption('with-php-version')) {
    $subject = $p->getInputOption('with-php-version');
    $pattern = '/(\d{1,2})\.(\d{1,2})\.(\d{1,})\w*/';
    if (preg_match($pattern, $subject, $match)) {
        $php_version = $match[0];
        $php_version_id =
            str_pad($match[1], 2, '0') .
            str_pad($match[2], 2, '0') .
            sprintf('%02d', $match[3]);
        $php_version_tag = 'php-' . $match[0];
    }
}

define('BUILD_PHP_VERSION', $php_version);
define('BUILD_PHP_VERSION_ID', intval($php_version_id));
define('BUILD_PHP_VERSION_TAG', $php_version_tag);
define('BUILD_CUSTOM_PHP_VERSION_ID', intval(substr($php_version_id, 0, 4))); //取主版本号和次版本号

echo "PHP_VERSION: " . BUILD_PHP_VERSION . PHP_EOL;
echo "PHP_VERSION_ID: " . BUILD_PHP_VERSION_ID . PHP_EOL;
echo "PHP_VERSION_TAG: " . BUILD_PHP_VERSION_TAG . PHP_EOL;
echo "CUSTOM_PHP_VERSION_ID: " . BUILD_CUSTOM_PHP_VERSION_ID . PHP_EOL;
echo PHP_EOL;


// Compile directly on the host machine, not in the docker container
if ($p->getInputOption('without-docker') || ($p->getOsType() == 'macos')) {
    $p->setWorkDir(__DIR__);
    $p->setBuildDir(__DIR__ . '/thirdparty');
}

$p->setRootDir(__DIR__);

//设置 PHP 源码所在目录 (构建时将进入此目录进行构建)
if ($p->getInputOption('with-php-src')) {
    $p->setPhpSrcDir($p->getInputOption('with-php-src'));
} else {
    $p->setPhpSrcDir($p->getRootDir() . '/thirdparty/php-src');
}

//设置PHP 安装目录
define("BUILD_PHP_INSTALL_PREFIX", $p->getRootDir() . '/bin/php-' . BUILD_PHP_VERSION);

if ($p->getInputOption('with-override-default-enabled-ext')) {
    $p->setExtEnabled([]);
}

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


if ($p->getInputOption('with-http-proxy')) {
    $http_proxy = $p->getInputOption('with-http-proxy');
    $proxyConfig = <<<EOF
export HTTP_PROXY={$http_proxy}
export HTTPS_PROXY={$http_proxy}
EOF;
    $proxyConfig .= PHP_EOL;
    $proxyConfig .= <<<'EOF'
export NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
export NO_PROXY="${NO_PROXY},127.0.0.1,localhost"
export NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
export NO_PROXY="${NO_PROXY},dl-cdn.alpinelinux.org"
export NO_PROXY="${NO_PROXY},deb.debian.org,security.debian.org"
export NO_PROXY="${NO_PROXY},archive.ubuntu.com,security.ubuntu.com"
export NO_PROXY="${NO_PROXY},pypi.python.org,bootstrap.pypa.io"
export NO_PROXY="${NO_PROXY},.sourceforge.net"
export NO_PROXY="${NO_PROXY},.gitee.com"

EOF;
    $p->setProxyConfig($proxyConfig, $http_proxy);
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

if (BUILD_CUSTOM_PHP_VERSION_ID < 7040) {
    putenv('SWOOLE_CLI_WITH_C_COMPILER=gcc');
}
if ($p->getInputOption('with-c-compiler')) {
    $c_compiler = $p->getInputOption('with-c-compiler');
    if ($c_compiler == 'gcc') {
        $p->set_C_COMPILER('gcc');
        $p->set_CXX_COMPILER('g++');
        $p->setLinker('ld');
    }
}

$p->setExtraCflags(' -Os');


// Generate make.sh
$p->execute();


function install_libraries(Preprocessor $p): void
{
    $p->loadDependentLibrary('php');
}
