export MACOSX_DEPLOYMENT_TARGET=13.4

# echo "编译 LuaJIT..."
# cd luajit-2.1.0b3

# make clean
# make && sudo make install

# cd ..

mkdir -p build_lj_osx && cd build_lj_osx
cmake -DUSING_LUAJIT=ON  -GXcode ../
cd ..
cmake --build build_lj_osx --config Release

# mkdir -p plugin_luajit/Plugins/xlua.bundle/Contents/MacOS/
rm -rf plugin_luajit/Plugins/xlua.bundle
cp -r build_lj_osx/Release/xlua.bundle plugin_luajit/Plugins/xlua.bundle

