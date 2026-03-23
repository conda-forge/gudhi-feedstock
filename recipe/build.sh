#!/bin/sh

# Download submodule
git submodule update --init

# Construct user version from devel version
mkdir build && cd build

cmake \
  -DWITH_GUDHI_THIRD_PARTY=OFF \
  -DUSER_VERSION_DIR=version \
  ..

make user_version

cd version

# Build and install user version

# install the python package
export SKBUILD_CMAKE_DEFINE="CMAKE_CXX_FLAGS='-D_LIBCPP_DISABLE_AVAILABILITY';CMAKE_C_FLAGS='-D_LIBCPP_DISABLE_AVAILABILITY'"
$PYTHON -m pip install . --no-build-isolation --no-deps -v

mkdir build && cd build

cmake ${CMAKE_ARGS} -LAH -G"$CMAKE_GENERATOR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DPython_EXECUTABLE="$PYTHON" \
  -DWITH_GUDHI_PYTHON=OFF \
  -DCMAKE_CXX_FLAGS="-D_LIBCPP_DISABLE_AVAILABILITY" \
  -DCMAKE_C_FLAGS="-D_LIBCPP_DISABLE_AVAILABILITY" \
  ..

cmake --build . -j${CPU_COUNT}
cmake --install .
