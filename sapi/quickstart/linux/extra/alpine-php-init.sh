apk search php
apk add php84-cli php84-dev
apk add php84-iconv php84-mbstring php84-phar php84-openssl
apk add php84-posix php84-tokenizer php84-intl
apk add php84-dom php84-xmlwriter php84-xml php84-simplexml
apk add php84-pdo php84-sockets php84-curl php84-mysqlnd php84-pgsql php84-sqlite3
apk add php84-redis php84-mongodb
apk add php84-redis php84-fileinfo

php84 -v
php84 --ini
php84 --ini | grep ".ini files"

ln -sf /usr/bin/php84 /usr/bin/php
ln -sf /usr/bin/phpize82 /usr/bin/phpize
ln -sf /usr/bin/php-config82 /usr/bin/php-config
