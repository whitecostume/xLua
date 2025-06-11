

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/luajit-2.1.0b3

OS=`uname -s`
PREBUILT_PLATFORM=linux-x86_64
if [[ "$OS" == "Darwin" ]]; then
    PREBUILT_PLATFORM=darwin-x86_64
fi

NDKABI=21

ANDROID_NDK=$ANDROID_NDK_HOME
echo "Building arm64-v8a lib"
NDKVER=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
NDKP=$NDKVER/bin/
NDKCC=$NDKP/aarch64-linux-android$NDKABI-clang
NDKCROSS=$NDKP/aarch64-linux-android-
NDKARCH="-DLJ_ABI_SOFTFP=0 -DLJ_ARCH_HASFPU=1 -DLUAJIT_ENABLE_GC64=1"  
cd "$SRCDIR"
make clean
make HOST_CC="clang -m64" CROSS=$NDKCROSS STATIC_CC=$NDKCC DYNAMIC_CC="$NDKCC -fPIC -O3" TARGET_LD=$NDKCC TARGET_AR="$NDKP/llvm-ar rcus" TARGET_STRIP="$NDKP/llvm-strip" TARGET_SYS=Linux TARGET_FLAGS="--sysroot $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot $NDKARCH"

cd "$DIR"
mkdir -p build_lj_v8a && cd build_lj_v8a
cmake -DUSING_LUAJIT=ON -DANDROID_ABI=arm64-v8a -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=aarch64-linux-android-clang -DANDROID_NATIVE_API_LEVEL=android-$NDKABI ../
cd "$DIR"
cmake --build build_lj_v8a --config Release
mkdir -p plugin_luajit/Plugins/Android/libs/arm64-v8a/
cp build_lj_v8a/libxlua.so plugin_luajit/Plugins/Android/libs/arm64-v8a/libxlua.so


echo "Building armv7 lib"
NDKVER=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
NDKP=$NDKVER/bin/
NDKCC=$NDKP/armv7a-linux-androideabi$NDKABI-clang
NDKCROSS=$NDKP/armv7a-linux-androideabi-
NDKARCH="-march=armv7-a -mfloat-abi=softfp"
cd "$SRCDIR"
make clean
make HOST_CC="clang -m32" CROSS=$NDKCROSS STATIC_CC=$NDKCC DYNAMIC_CC="$NDKCC -fPIC -O3" TARGET_LD=$NDKCC TARGET_AR="$NDKP/llvm-ar rcus" TARGET_STRIP="$NDKP/llvm-strip" TARGET_SYS=Linux TARGET_FLAGS="--sysroot $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot $NDKARCH"

cd "$DIR"
mkdir -p build_lj_v7a && cd build_lj_v7a
cmake -DUSING_LUAJIT=ON -DANDROID_ABI=armeabi-v7a -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-clang -DANDROID_NATIVE_API_LEVEL=android-$NDKABI ../
cd "$DIR"
cmake --build build_lj_v7a --config Release
mkdir -p plugin_luajit/Plugins/Android/libs/armeabi-v7a/
cp build_lj_v7a/libxlua.so plugin_luajit/Plugins/Android/libs/armeabi-v7a/libxlua.so

echo "Building x86 lib"
NDKP=$NDKVER/bin/
NDKCC=$NDKP/i686-linux-androideabi$NDKABI-clang
NDKCROSS=$NDKP/i686-linux-androideabi-
NDKARCH="-march=x86 -mfloat-abi=softfp"
cd "$SRCDIR"
make clean
make HOST_CC="clang -m32" CROSS=$NDKCROSS STATIC_CC=$NDKCC DYNAMIC_CC="$NDKCC -fPIC -O3" TARGET_LD=$NDKCC TARGET_AR="$NDKP/llvm-ar rcus" TARGET_STRIP="$NDKP/llvm-strip" TARGET_SYS=Linux TARGET_FLAGS="--sysroot $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot  $NDKARCH"

cd "$DIR"
mkdir -p build_lj_x86 && cd build_lj_x86
cmake -DUSING_LUAJIT=ON -DANDROID_ABI=x86 -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=i686-linux-android-clang -DANDROID_NATIVE_API_LEVEL=android-$NDKABI ../
cd "$DIR"
cmake --build build_lj_x86 --config Release
mkdir -p plugin_luajit/Plugins/Android/libs/x86/
cp build_lj_x86/libxlua.so plugin_luajit/Plugins/Android/libs/x86/libxlua.so

