#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../../../../
  pwd
)
cd ${__PROJECT__}

export PATH=${__PROJECT__}/bin/runtime:$PATH

# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
composer update


<<<<<<< HEAD:sapi/quickstart/linux/x86_64/prepare.sh
php prepare.php  --with-build-type=release -gd   -imagick -soap -mysqli  #  intl zip  暂启用不了

# php prepare.php  --with-build-type=release +apcu +ds

=======
php prepare.php  --with-build-type=release +apcu +ds

exit 0
# use sfx micro
php prepare.php  --with-build-type=release +apcu +ds --with-php-sfx-micro=1
>>>>>>> build_native_php:sapi/quickstart/linux/x86_64/prepare2.sh
