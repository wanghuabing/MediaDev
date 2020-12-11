#!/bin/sh
ANDROID_API=android-9
NDK_HOME=$HOME/Android/android-ndk-r9d
TOOLCHAIN=$NDK_HOME/platforms/$ANDROID_API/arch-arm
PLATFORM=$NDK_HOME/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86/bin/
CROSS_COMPILE=${PLATFORM}/arm-linux-androideabi-

ARM_INC=$TOOLCHAIN/usr/include
ARM_LIB=$TOOLCHAIN/usr/lib
LDFLAGS=" -nostdlib -Bdynamic -Wl,--whole-archive -Wl,--no-undefined -Wl,-z,noexecstack  -Wl,-z,nocopyreloc -Wl,-soname,/system/lib/libz.so -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker -L$NDK_HOME/sources/cxx-stl/gnu-libstdc++/libs/armeabi -L$NDK_HOME/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86/arm-linux-androideabi/lib -L$ARM_LIB  -lc -lgcc -lm -ldl  "
FLAGS="--host=arm-androideabi-linux --enable-static --disable-shared"
export CXX="${CROSS_COMPILE}g++ --sysroot=${TOOLCHAIN}"
export LDFLAGS="$LDFLAGS"
export CC="${CROSS_COMPILE}gcc --sysroot=${TOOLCHAIN}"

PREFIX=$(pwd)/../libffmpeg/fdk-aac
./configure $FLAGS \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-static \
    --host=arm-linux \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --sysroot=$PLATFORM
make
make install
ldconfig
