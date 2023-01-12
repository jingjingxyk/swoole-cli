#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)
cd ${__DIR__}
cd ${__PROJECT__}

# bash  build-tools-scripts/download-init-depend-use-proxy.sh harfbuzz-6.0.0.tar.gz

:<<'EOF'
if [ -z "$1" ]; then
    set -e
	package_name=$1
	file=${__PROJECT__}/pool/lib/$package_name
    echo $file
    test -f $file && rm -rf  $file
fi



if [ -z "$2" ]; then
  proxy_url=$2
fi
EOF

proxy_url='http://192.168.3.26:8015'
if test -n $proxy_url
then
  export http_proxy=$proxy_url
  export https_proxy=$proxy_url
  pear config-set http_proxy $http_proxy
  pecl config-show
  git config --global --add safe.directory '*'
  git submodule update --init --recursive
  # SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
  # php prepare.php  +mongodb +inotify
  # php prepare.php   -inotify -imagick -gd -intl -posix -mysqli -soap -exif  -opcache -pcntl
  php prepare.php   \
  +pgsql -pdo_pgsql \
  -pdo_mysql -mysqli  -mysqlnd \
  -sqlite3 -pdo_sqlite \
  -mongodb \
  -redis \
  -intl \
  -imagick -gd -exif \
  -bz2 -zlib -zip \
  -opcache -pcntl  -tokenizer \
  -swoole  -yaml   -opcache  \
  -sodium \
  -gmp  -bcmath \
  -phar -mbstring \
  -inotify \
  -ds   -posix   -soap   \
  -sockets

  pear config-set http_proxy ''

else
    git config --global --add safe.directory '*'
    git submodule update --init --recursive
    # SKIP_LIBRARY_DOWNLOAD=1 php prepare.php +mongodb +inotify
    # php prepare.php  +mongodb +inotify
    php prepare.php   +inotify
fi






chmod a+x ./make.sh

chown -R 1000:1000 .

:<<'EOF'
cho -e "Enter numbers 1-4" \c"
read NUM
case $NUM in
    1) echo "one";;
    2) echo "two";;
    3) echo "three";;
    4) echo "four";;
    *) echo "invalid answer"
       exit 1;;
esac
EOF
