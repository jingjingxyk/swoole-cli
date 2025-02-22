
export LOGICAL_PROCESSORS=$(nproc 2> /dev/null || sysctl -n hw.ncpu)
export CMAKE_BUILD_PARALLEL_LEVEL=${LOGICAL_PROCESSORS}

test -f openssl-3.4.0.tar.gz || curl -fSLo openssl-3.4.0.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz
test -d openssl-3.4.0 && rm -rf openssl-3.4.0
tar -xvf openssl-3.4.0.tar.gz
cd openssl-3.4.0

perl ./Configure --prefix=/usr/local/Cellar/openssl@3/3.4.0 --openssldir=/usr/local/etc/openssl@3 --libdir=lib no-ssl3 no-ssl3-method no-zlib darwin64-x86_64
make -j $(LOGICAL_PROCESSORS)
make install MANDIR=/usr/local/Cellar/openssl@3/3.4.0/share/man MANSUFFIX=ssl

