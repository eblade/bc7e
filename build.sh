#!/usr/bin/env bash
set -eu

repo_dir="$PWD"
build_dir="$PWD/build"
install_dir="$PWD/install"
package_name="bc7e-linux.tar.gz"


mkdir -p "$build_dir"
rm -r "$build_dir"
mkdir -p "$build_dir"
cd "$build_dir"
cd "$repo_dir"

echo "Copying files..."
cp bc7e.ispc bc7decomp.c bc7decomp.h bc7enc.cpp lodepng.cpp lodepng.h dds_defs.h "$build_dir"
cd "$build_dir"

echo "Compiling with ISPC..."
ispc -g -O2 "bc7e.ispc" -o "bc7e.obj" -h "bc7e_ispc.h" --target=sse2,sse4,avx,avx2 --opt=fast-math --opt=disable-assertions

echo "Packing libbc7e..."
ar -crs libbc7e.a bc7e*.obj

echo "Compiling libodepng..."
g++ -c lodepng.cpp -o liblodepng.a

echo "Compiling bc7decomp..."
g++ -lomp -L. -llodepng -c bc7decomp.c -o libbc7decomp.a

echo "Compiling bc7enc..."
g++ -lomp -L. -llodepng -lbc7decomp bc7enc.cpp libbc7e.a -o bc7enc

echo "Creating install dir..."
cd "$repo_dir"
mkdir -p "$install_dir"
rm -r "$install_dir"
mkdir -p "$install_dir/bin"
mkdir -p "$install_dir/lib"
mkdir -p "$install_dir/include"
cp "$build_dir/bc7enc" "$install_dir/bin/"
cp "$build_dir/libbc7e.a" "$install_dir/lib/"
cp "$build_dir/bc7e_ispc.h" "$install_dir/include/"
cp "$build_dir/bc7e_ispc_sse2.h" "$install_dir/include/"
cp "$build_dir/bc7e_ispc_sse4.h" "$install_dir/include/"
cp "$build_dir/bc7e_ispc_avx.h" "$install_dir/include/"
cp "$build_dir/bc7e_ispc_avx2.h" "$install_dir/include/"
cp "README" "$install_dir/"
cp "CMakeLists.txt.in" "$install_dir/CMakeLists.txt"

echo "Packing..."
cd "$repo_dir"
tar -C "$install_dir" -czf "$package_name" "./lib" "./bin" "./include" "README" "CMakeLists.txt"
