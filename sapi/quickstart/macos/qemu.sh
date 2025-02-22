
export LOGICAL_PROCESSORS=$(nproc 2> /dev/null || sysctl -n hw.ncpu)
export CMAKE_BUILD_PARALLEL_LEVEL=${LOGICAL_PROCESSORS}



test -f qemu-9.2.0.tar.xz ||  curl -fSLo qemu-9.2.0.tar.xz https://download.qemu.org/qemu-9.2.0.tar.xz
test -d  qemu-9.2.0 && rm -rf qemu-9.2.0
tar xvJf qemu-9.2.0.tar.xz
cd qemu-9.2.0
./configure
make -j ${LOGICAL_PROCESSORS}
