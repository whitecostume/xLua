mkdir -p build_lj_osx && cd build_lj_osx
cmake -DUSING_LUAJIT=ON  -GXcode ../
cd ..
cmake --build build_lj_osx --config Release
# 打印 build_lj_osx 目录的内容 递归显示
echo "Contents of build_lj_osx directory:"
ls build_lj_osx -R

mkdir -p plugin_luajit/Plugins/xlua.bundle/Contents/MacOS/
cp build_lj_osx/Release/xlua.bundle/Contents/MacOS/xlua plugin_luajit/Plugins/xlua.bundle/Contents/MacOS/xlua

