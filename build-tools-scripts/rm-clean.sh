
set -exu

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

__ROOT__=$(
  cd ${__DIR__}/../
  pwd
)


__PROJECT__=${__ROOT__}
cd ${__DIR__}




cd ${__PROJECT__}

test -f ${__PROJECT__}/build-tools-scripts/fpm_main_backup.c || cp -f ${__PROJECT__}/sapi/cli/fpm/fpm_main.c ${__PROJECT__}/build-tools-scripts/fpm_main_backup.c
test -f ${__PROJECT__}/build-tools-scripts/main.backup.c  || cp -f ${__PROJECT__}/main/main.c ${__PROJECT__}/build-tools-scripts/main.backup.c

cd ${__PROJECT__}

test -d ${__PROJECT__}/thirdparty && rm -rf ${__PROJECT__}/thirdparty/*


test -f  Makefile.objects &&  rm -rf Makefile.objects
test -f  Makefile.fragments &&  rm -rf Makefile.fragments
test -f  Makefile &&  rm -rf Makefile
test -f  make.sh &&  rm -rf make.sh
test -f  libtool &&  rm -rf libtool
test -f  configure &&  rm -rf configure
test -f  config.status &&  rm -rf config.status
test -f  config.nice &&  rm -rf config.nice
test -f  config.log &&  rm -rf config.log
test -d  include &&  rm -rf include
test -d  libs &&  rm -rf libs
test -d  modules &&  rm -rf modules


cd ${__PROJECT__}/
rm -rf ext/*
rm -rf Zend/*
rm -rf main/*
rm -rf build/*

cd ${__PROJECT__}/scripts
test -f php-config &&  rm -rf php-config
test -f phpize &&  rm -rf phpize
test -f man1/php-config.1 &&  rm -rf man1/php-config.1
test -f man1/phpize.1 &&  rm -rf  man1/phpize.1



cd ${__PROJECT__}/Zend
rm -rf *.dep
rm -rf *.lo
rm -rf *.o
test -d .libs && rm -rf .libs

cd ${__PROJECT__}/

if test -d ${__PROJECT__}/Zend/asm ;
then
  cd ${__PROJECT__}/Zend/asm
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi

cd ${__PROJECT__}/

if test -d ${__PROJECT__}/Zend/Optimizer ;
then
  cd ${__PROJECT__}/Zend/Optimizer
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi
cd ${__PROJECT__}/

if test -d ${__PROJECT__}/TSRM ;
then
  cd ${__PROJECT__}/TSRM
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi
cd ${__PROJECT__}/

if test -d ${__PROJECT__}/sapi/cli ;
then
  cd ${__PROJECT__}/sapi/cli
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi
cd ${__PROJECT__}/

test -f ${__PROJECT__}/sapi/cli/php.1 && rm -rf ${__PROJECT__}/sapi/cli/php.1

if test -d ${__PROJECT__}/sapi/cli/fpm ;
then
  cd ${__PROJECT__}/sapi/cli/fpm
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi
cd ${__PROJECT__}/


if test -d ${__PROJECT__}/sapi/cli/fpm/events ;
then
  cd ${__PROJECT__}/sapi/cli/fpm/events
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi
cd ${__PROJECT__}/

if test -d ${__PROJECT__}/main ;
then
  cd ${__PROJECT__}/main
  test -d .libs && rm -rf .libs
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi

cd ${__PROJECT__}/main

test -f build-defs.h && rm -rf build-defs.h
test -f internal_functions.c && rm -rf internal_functions.c
test -f internal_functions_cli.c && rm -rf internal_functions_cli.c
test -f php_config.h && rm -rf php_config.h
test -f php_config.h.in && rm -rf php_config.h.in

cd ${__PROJECT__}/

if test -d ${__PROJECT__}/main/streams/ ;
then
  cd ${__PROJECT__}/main/streams/
  rm -rf *.dep
  rm -rf *.lo
  rm -rf *.o
fi
cd ${__PROJECT__}/


rm -rf autom4te.cache
cd ${__PROJECT__}/bin/
rm -rf .libs

cd ${__PROJECT__}/



cd ${__DIR__}
sh download-php-sourcecode.sh

cd ${__DIR__}

cd ${__PROJECT__}/

chown -R 1000:1000 .
git config --global --add safe.directory '*'
git submodule update --init --recursive

cd ${__DIR__}
sh download-init-depend-use-proxy.sh

cd ${__PROJECT__}/
sh make.sh sync

test -f ${__PROJECT__}/build-tools-scripts/fpm_main_backup.c &&  cp -f ${__PROJECT__}/build-tools-scripts/fpm_main_backup.c  ${__PROJECT__}/sapi/cli/fpm/fpm_main.c

cd ${__DIR__}
sh download-init-depend-use-proxy.sh

chown -R 1000:1000 .


# rm -rf ${__PROJECT__}/build-tools-scripts/php-versions/php-8.1.12














exit 0

cd ${__PROJECT__}/ext

for i in `ls ${__PROJECT__}/ext/`
do
  rm -rf $i/*.dep
  rm -rf $i/*.lo
  rm -rf $i/*.o
done

exit 0
cd ${__PROJECT__}/thirdparty
find . -type d -exec rm -rf {} \;

cd ${__PROJECT__}/
