<?php


use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    //PHP 构建选项
    $options = ' --enable-opentelemetry ';

    $ext = (new Extension('opentelemetry'))
        ->withOptions($options)
        ->withLicense('https://github.com/open-telemetry/opentelemetry-php-instrumentation/blob/main/LICENSE', Extension::LICENSE_APACHE2)
        ->withHomePage('https://github.com/open-telemetry/opentelemetry-php-instrumentation.git')
        ->withManual('https://github.com/open-telemetry/opentelemetry-php-instrumentation.git')
        ->withFile('opentelemetry-latest.tar.gz')
        ->withDownloadScript(
            'opentelemetry-php-instrumentation', # 待打包目录名称
            <<<EOF
            git clone -b main --depth=1 https://github.com/open-telemetry/opentelemetry-php-instrumentation.git

EOF
        );
    $p->addExtension($ext);
};
