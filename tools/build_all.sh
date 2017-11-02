#!/bin/bash -e

export CC=`pwd`/toolchain/gcc-linaro-6.4.1-2017.08-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

cd ./u-boot/u-boot-2017.11-rc3/

patch -p1 < ../0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch
patch -p1 < ../0002-U-Boot-BeagleBone-Cape-Manager.patch

make ARCH=arm CROSS_COMPILE=${CC} distclean
make ARCH=arm CROSS_COMPILE=${CC} am335x_evm_defconfig
make -j3 ARCH=arm CROSS_COMPILE=${CC}
cd ../../

cd ./linux/linux-4.14-rc7/
patch -p1 < ../patch-4.14-rc7-bone3.diff
make ARCH=arm CROSS_COMPILE=${CC} distclean
cp -v ../defconfig ./.config
#make ARCH=arm CROSS_COMPILE=${CC} menuconfig
make -j3 ARCH=arm CROSS_COMPILE=${CC} zImage modules
make ARCH=arm CROSS_COMPILE=${CC} dtbs
cd ../../