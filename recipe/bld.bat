set CMAKE_CONFIG=Release
set CMAKE_GENERATOR=NMake Makefiles

:: Construct user version from devel version

mkdir build && cd build

echo cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DUSER_VERSION_DIR=version ..
cmake -LAH -G"%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" -DUSER_VERSION_DIR=version .. || goto :eof

echo cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION
cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION || goto :eof

cd version

:: Build and install user version

mkdir build && cd build

:: Lines to be removed :
::  -DWITH_GUDHI_TEST=OFF ^
::  -DWITH_GUDHI_UTILITIES=OFF ^

echo cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DPython_ADDITIONAL_VERSIONS=${PY_VER} ^
  -DPYTHON_EXECUTABLE="%PYTHON%" ^
  -DWITH_GUDHI_PYTHON=OFF ^
  -DWITH_GUDHI_TEST=OFF ^
  -DWITH_GUDHI_UTILITIES=OFF ^
  ..
cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DPython_ADDITIONAL_VERSIONS=${PY_VER} ^
  -DPYTHON_EXECUTABLE="%PYTHON%" ^
  -DWITH_GUDHI_PYTHON=OFF ^
  -DWITH_GUDHI_TEST=OFF ^
  -DWITH_GUDHI_UTILITIES=OFF ^
  .. || goto :eof

echo cmake --build . --config %CMAKE_CONFIG% --target INSTALL
cmake --build . --config %CMAKE_CONFIG% --target INSTALL || goto :eof

echo cmake -DWITH_GUDHI_PYTHON=ON .
cmake -DWITH_GUDHI_PYTHON=ON . || goto :eof

cd python
echo python setup.py install
python setup.py install
