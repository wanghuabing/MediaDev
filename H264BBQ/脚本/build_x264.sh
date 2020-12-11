#!/bin/bash

ARM_ROOT=$HOME/android/android-ndk-r9d
ARM_INC=$ARM_ROOT/platforms/android-9/arch-arm/usr/include/
ARM_LIB=$ARM_ROOT/platforms/android-9/arch-arm/usr/lib/
ARM_TOOL=$ARM_ROOT/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86
ARM_LIBO=$ARM_TOOL/lib/gcc/arm-linux-androideabi/4.8
ARM_PRE=arm-linux-androideabi
PREFIX=$(pwd)/../libffmpeg/x264 

./configure --disable-gpac \
    	--disable-cli \
	--enable-pic \
	--enable-strip \
    	--enable-static \
	--cross-prefix=$ARM_TOOL/bin/arm-linux-androideabi- \
	--host=arm-linux \
	--prefix=$PREFIX \
	--extra-cflags="-I$ARM_INC -fPIC -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__  -Wno-psabi -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP" \
	--extra-ldflags="-nostdlib -Bdynamic -Wl,--no-undefined -Wl,-z,noexecstack  -Wl,-z,nocopyreloc -Wl,-soname,/system/lib/libz.so -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker -L$ARM_LIB -nostdlib $ARM_LIB/crtbegin_dynamic.o $ARM_LIB/crtend_android.o -lc -lm -ldl -lgcc"

make clean 
make
make install
ldconfig
