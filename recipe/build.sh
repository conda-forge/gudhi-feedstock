#!/bin/sh

# Construct user version from devel version
mkdir build && cd build

cmake \
  -DUSER_VERSION_DIR=version \
  ..

make user_version

cd version

# Build and install user version

mkdir build && cd build

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DPython_ADDITIONAL_VERSIONS="${PY_VER}" \
  -DPYTHON_EXECUTABLE="$PYTHON" \
  -DWITH_GUDHI_PYTHON=OFF \
  ..

# install include files and utils
make install -j${CPU_COUNT}

# install the python package
cmake -DWITH_GUDHI_PYTHON=ON .
cd cython
$PYTHON setup.py install
