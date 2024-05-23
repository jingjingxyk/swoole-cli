@echo off

: set LDFLAGS=" -L"C:/Program Files/OpenSSL/lib/" -lssl -lcrypto -lssl -L"C:/Program Files (x86)/zlib/lib" -lz "

set CPPFLAGS="%INCLUDE%;c:\php-cli\openssl\include\;c:\php-cli\zlib\include"
set LDFLAGS="%LIB%;c:\php-cli\openssl\lib\;c:\php-cli\zlib\lib"
set LIB="%LIB%;c:\php-cli\openssl\lib\;c:\php-cli\zlib\lib"
set LIBPATH="%LIBPATH%;c:\php-cli\openssl\lib\;c:\php-cli\zlib\lib"
echo %INCLUDE%
echo %LIB%

configure ^
--disable-all      --disable-cgi      --enable-cli ^
--enable-sockets    --enable-mbstring  --enable-ctype  --enable-pdo --enable-phar  ^
--enable-fileinfo   --enable-filter ^
--enable-xmlreader  --enable-xmlwriter ^
--enable-zlib ^
--with-openssl=static ^
--with-extra-includes="c:\php-cli\openssl\include\;c:\php-cli\zlib\include" ^
--with-extra-libs="c:\php-cli\openssl\lib\;c:\php-cli\zlib\lib"


: --with-curl=static