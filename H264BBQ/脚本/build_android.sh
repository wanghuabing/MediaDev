#!/bin/bash
######################################################
# Usage:
# put this script in top of FFmpeg source tree
# ./build_android
#
# It generates binary for following architectures:
# ARMv6 
# ARMv6+VFP 
# ARMv7+VFPv3-d16 (Tegra2)
# ARMv7+Neon (Cortex-A8)
#
# Customizing:
# 1. Feel free to change ./configure parameters for more features
# 2. To adapt other ARM variants
# set $CPU and $OPTIMIZE_CFLAGS 
# call build_one
######################################################
#change these three lines if you want to build using different vesion of Android ndk
#build_one is for ndk 8, and build_one_r6 is for ndk 9
NDK=$HOME/android/android-ndk-r9d
PLATFORM=$NDK/platforms/android-9/arch-arm
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86
X264_HOME=$(pwd)/../libffmpeg/x264
AAC_HOME=$(pwd)/../libffmpeg/fdk-aac
ARM_LIBO=$TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.8
PREFIX=$(pwd)/../libffmpeg/ffmpeg 
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86

ARM_ROOT=$HOME/android/android-ndk-r9d
ARM_INC=$ARM_ROOT/platforms/android-9/arch-arm/usr/include
ARM_LIB=$ARM_ROOT/platforms/android-9/arch-arm/usr/lib
ARM_TOOL=$ARM_ROOT/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86
ARM_LIBO=$ARM_TOOL/lib/gcc/arm-linux-androideabi/4.8

function build_one
{
./configure \
	--prefix=$PREFIX \
        --disable-shared \
	--enable-static \
	--arch=arm \
	--target-os=linux \
	--enable-cross-compile \
    	--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
    	--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
    	--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
	--sysroot=$PLATFORM \
    	--enable-memalign-hack \
	--enable-ffmpeg \
	--enable-ffplay \
	--disable-ffserver \
        --disable-ffprobe \
	--disable-devices \
        --enable-avresample  \
	--enable-swscale  \
	--enable-nonfree \
	--enable-gpl \
	--enable-zlib \
	--enable-doc \
	--enable-version3 \
	--enable-optimizations \
	--enable-network \
    	--enable-indevs \
	--enable-pic \
	--enable-protocols \
	--disable-doc \
    	--disable-debug \
	--enable-filters      \
	--enable-demuxers      \
	--enable-muxers        \
	--enable-encoders  \
	--enable-decoders  \
	--enable-parsers \
	--enable-libx264 \
	--sysinclude=$PLATFORM/usr/include \
	--extra-cflags="-I$ARM_INC -fPIC -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -march=armv7-a -mtune=cortex-a8 -mfloat-abi=softfp -mfpu=neon -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__  -Wno-psabi -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP -I$AAC_HOME/include  -I$X264_HOME/include" \
	--extra-ldflags="-nostdlib -Bdynamic -Wl,--no-undefined -Wl,-z,noexecstack  -Wl,-z,nocopyreloc -Wl,-soname,/system/lib/libz.so -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker -L$ARM_LIB -nostdlib $ARM_LIB/crtbegin_dynamic.o $ARM_LIB/crtend_android.o -L$X264_HOME/lib -lx264 -L$AAC_HOME/lib -lc -lm -ldl -lgcc"

make clean
make
make install
}

#arm v6
#CPU=armv6
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/$CPU 
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7vfpv3
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
##PREFIX=./android/$CPU
#ADDITIONAL_CONFIGURE_FLAG=
#build_one
#build_one_r6

#arm v7vfp
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
##PREFIX=./android/$CPU-vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7n
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
#PREFIX=./android/$CPU 
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
build_one

#arm v6+vfp
#CPU=armv6
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp 
#ADDITIONAL_CONFIGURE_FLAG=
#build_one
