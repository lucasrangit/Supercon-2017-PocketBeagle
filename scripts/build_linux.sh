#!/bin/bash -e

CORES=$(getconf _NPROCESSORS_ONLN)

export CC=`pwd`/toolchain/gcc-linaro-6.4.1-2017.08-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

cd ./linux/linux-4.14-rc8/

if [ ! -f ./arch/arm/configs/rcn-ee_defconfig ] ; then
	patch -p1 < ../patch-4.14-rc8-bone3.diff
fi

make ARCH=arm CROSS_COMPILE=${CC} distclean
cp -v ../defconfig ./.config
make ARCH=arm CROSS_COMPILE=${CC} menuconfig
cp -v ./.config ../defconfig

make -j${CORES} ARCH=arm CROSS_COMPILE=${CC} zImage modules

make ARCH=arm CROSS_COMPILE=${CC} dtbs

make -s ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=../../deploy/tmp/

cd ../../deploy/tmp/
tar --create --gzip --file ../modules.tar.gz ./
cd ../../linux/linux-4.14-rc8/

rm -rf ../../deploy/tmp/

if [ -f arch/arm/boot/zImage ] ; then
	cp -v arch/arm/boot/zImage ../../deploy/zImage
fi

if [ -f arch/arm/boot/dts/am335x-pocketbeagle.dtb ] ; then
	cp -v arch/arm/boot/dts/am335x-pocketbeagle.dtb ../../deploy/am335x-pocketbeagle.dtb
fi

cd ../../

ls -lh ./deploy/
