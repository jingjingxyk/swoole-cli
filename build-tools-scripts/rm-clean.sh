
set -exu

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

__ROOT__=$(
  cd "$(dirname "$0")"
  cd ..
  pwd
)

__DIR__=${__ROOT__}
cd ${__DIR__}

test -f  Makefile.objects &&  rm -rf Makefile.objects
test -f  Makefile.fragments &&  rm -rf Makefile.fragments
test -f  Makefile &&  rm -rf Makefile
test -f  make.sh &&  rm -rf make.sh
test -f  libtool &&  rm -rf libtool
test -f  configure &&  rm -rf configure
test -f  config.status &&  rm -rf config.status
test -f  config.nice &&  rm -rf config.nice
test -f  config.log &&  rm -rf config.log

cd ${__DIR__}/Zend
rm -rf *.dep
rm -rf *.lo
rm -rf *.o
cd ${__DIR__}/Zend/asm
rm -rf *.dep
rm -rf *.lo
rm -rf *.o
cd ${__DIR__}/Zend/Optimizer
rm -rf *.dep
rm -rf *.lo
rm -rf *.o

cd ${__DIR__}/TSRM
rm -rf *.dep
rm -rf *.lo
rm -rf *.o

cd ${__DIR__}/thirdparty
find ${__DIR__}/thirdparty/ -type d -exec rm -rf  \;

cd ${__DIR__}/scripts
rm -rf php-config
rm -rf phpize
rm -rf man1/php-config.1
rm -rf  man1/phpize.1


cd ${__DIR__}/sapi/cli
rm -rf *.dep
rm -rf *.lo
rm -rf *.o
rm -rf php.1
cd ${__DIR__}/sapi/cli/fpm
rm -rf *.dep
rm -rf *.lo
rm -rf *.o
cd ${__DIR__}/sapi/cli/fpm/events
rm -rf *.dep
rm -rf *.lo
rm -rf *.o

cd ${__DIR__}/main
rm -rf *.dep
rm -rf *.lo
rm -rf *.o
rm -rf build-defs.h
rm -rf internal_functions.c
rm -rf internal_functions_cli.c
rm -rf php_config.h
rm -rf php_config.h.in
cd ${__DIR__}/main/streams/
rm -rf *.dep
rm -rf *.lo
rm -rf *.o

cd ${__DIR__}
rm -rf autom4te.cache
cd ${__DIR__}/bin/
rm -rf .libs

cd ${__DIR__}/ext

for i in `ls ${__DIR__}/ext/`
do
  rm -rf $i/*.dep
  rm -rf $i/*.lo
  rm -rf $i/*.o
done

cd ${__DIR__}/
