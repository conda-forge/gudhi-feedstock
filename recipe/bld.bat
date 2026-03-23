set CMAKE_CONFIG=Release
set CMAKE_GENERATOR=Ninja

:: Download submodule
git submodule update --init

:: Construct user version from devel version

mkdir build && cd build
echo cmake -LAH -G"%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" -DWITH_GUDHI_PYTHON=OFF -DUSER_VERSION_DIR=version ..
cmake -LAH -G"%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" -DWITH_GUDHI_PYTHON=OFF -DUSER_VERSION_DIR=version .. || goto :eof

echo cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION
cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION || goto :eof

cd version

:: Build Python package and install it

echo %PYTHON% -m pip install . --no-build-isolation --no-deps -v
%PYTHON% -m pip install . --no-build-isolation --no-deps -v || goto :eof

:: Build and install user version

mkdir release && cd release

echo cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DBoost_USE_STATIC_LIBS=OFF ^
  -DFORCE_EIGEN_DEFAULT_DENSE_INDEX_TYPE_TO_INT=ON ^
  -DWITH_GUDHI_PYTHON=OFF ^
  -DWITH_GUDHI_TEST=OFF ^
  -DWITH_GUDHI_UTILITIES=ON ^
  ..
cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DBoost_USE_STATIC_LIBS=OFF ^
  -DFORCE_EIGEN_DEFAULT_DENSE_INDEX_TYPE_TO_INT=ON ^
  -DWITH_GUDHI_PYTHON=OFF ^
  -DWITH_GUDHI_TEST=OFF ^
  -DWITH_GUDHI_UTILITIES=ON ^
  .. || goto :eof

echo cmake --build . --config %CMAKE_CONFIG% --target INSTALL
cmake --build . --config %CMAKE_CONFIG% --target INSTALL
