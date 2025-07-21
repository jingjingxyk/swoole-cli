apk add php7-cli php7-dev
apk add php7-iconv php7-mbstring php7-phar php7-openssl
apk add php7-posix php7-tokenizer php7-intl
apk add php7-dom php7-xmlwriter php7-xml php7-simplexml
apk add php7-pdo php7-sockets php7-curl php7-mysqlnd php7-pgsql php7-sqlite3
apk add php7-redis php7-fileinfo

php7 -v
php7 --ini
php7 --ini | grep ".ini files"

ln -sf /usr/bin/php7 /usr/bin/php
ln -sf /usr/bin/phpize7 /usr/bin/phpize
ln -sf /usr/bin/php-config7 /usr/bin/php-config
