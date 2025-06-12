export MACOSX_DEPLOYMENT_TARGET=13.4

# echo "编译 LuaJIT..."
cd luajit-2.1.0b3

# 编译 x86_64和 arm64
make clean
make TARGET_SYS=Darwin CC="clang -arch x86_64"
mv src/libluajit.a src/libluajit_x86_64.a

# 保存主机工具，避免被 clean 删除
cp src/host/minilua src/host/minilua_backup 2>/dev/null || true
cp src/host/buildvm src/host/buildvm_backup 2>/dev/null || true

make clean
# 恢复主机工具
cp src/host/minilua_backup src/host/minilua 2>/dev/null || true
cp src/host/buildvm_backup src/host/buildvm 2>/dev/null || true

make TARGET_SYS=Darwin CC="clang -arch arm64" HOST_CC="clang"
mv src/libluajit.a src/libluajit_arm64.a
# 合并 x86_64 和 arm64 的库
lipo -create src/libluajit_x86_64.a src/libluajit_arm64.a -output src/libluajit.a

cd ..

mkdir -p build_lj_osx && cd build_lj_osx
cmake -DUSING_LUAJIT=ON  -GXcode ../
cd ..
cmake --build build_lj_osx --config Release

# mkdir -p plugin_luajit/Plugins/xlua.bundle/Contents/MacOS/
rm -rf plugin_luajit/Plugins/xlua.bundle
cp -r build_lj_osx/Release/xlua.bundle plugin_luajit/Plugins/xlua.bundle

