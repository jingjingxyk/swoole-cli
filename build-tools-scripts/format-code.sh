#!/bin/env bash

set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}


__PROJECT__=$(readlink -f ${__DIR__}/../)

cd ${__PROJECT__}

php  ${__PROJECT__}/vendor/bin/php-cs-fixer  fix  --config=./.php-cs-fixer.dist.php



exit 0
php  ${__PROJECT__}/vendor/bin/php-cs-fixer  fix ${__PROJECT__}/sapi/Preprocessor.php --rules=@PSR12
php  ${__PROJECT__}/vendor/bin/phpcs --standard=PSR12 ${__PROJECT__}/conf.d
php  ${__PROJECT__}/vendor/bin/phpcbf --standard=PSR12 ${__PROJECT__}/conf.d

php  ${__PROJECT__}/vendor/bin/php-cs-fixer  fix ${__PROJECT__}/conf.d --rules=@PSR12


php vendor/bin/php-cs-fixer  fix conf.d,sapi --rules=@PSR12 --show-progress
