<?php

require __DIR__ . '/vendor/autoload.php';

use SwooleCli\Preprocessor;
use SwooleCli\Library;

$homeDir = getenv('HOME');
$p = Preprocessor::getInstance();
$p->parseArguments($argc, $argv);

# PHP 默认版本
$version = '8.2.4';

if ($p->getInputOption('with-php-version')) {
    $subject = $p->getInputOption('with-php-version');
    $pattern = '/(\d{1,2})\.\d{1,2}\.\d{1,2}/';
    if (preg_match($pattern, $subject, $match)) {
        if (intval($match[1]) >= 8) {
            $version = $match[0];
        }
    }
}

define('BUILD_PHP_VERSION', $version);


// Compile directly on the host machine, not in the docker container
if ($p->getInputOption('without-docker') || ($p->getOsType() == 'macos')) {
    $p->setWorkDir(__DIR__);
    $p->setBuildDir(__DIR__ . '/thirdparty');
}

// Sync code from php-src
//设置 PHP 源码所在目录
$p->setPhpSrcDir($p->getWorkDir() . '/php-src');

//设置PHP 安装目录
define("BUILD_PHP_INSTALL_PREFIX", $p->getWorkDir() . '/bin/php-' . BUILD_PHP_VERSION);

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

$p->setExtraCflags('-Os');


// Generate make.sh
$p->execute();


function install_libraries(Preprocessor $p): void
{
    $p->addLibrary(
        (new Library('php_patch_sfx_micro'))
            ->withUrl('https://github.com/dixyes/phpmicro.git')
            ->withHomePage('https://github.com/dixyes/phpmicro.git')
            ->withManual('https://github.com/dixyes/phpmicro')
            ->withLicense('https://github.com/dixyes/phpmicro/blob/master/LICENSE', Library::LICENSE_APACHE2)
            ->withFile('phpmicro-master.tar.gz')
            ->withDownloadScript(
                'phpmicro',
                <<<EOF
                        git clone -b master --depth=1 https://github.com/dixyes/phpmicro.git
EOF
            )
            ->withBuildScript('return 0')
            ->withLdflags('')
    );
    $p->loadDependentLibrary('php_src');
}
