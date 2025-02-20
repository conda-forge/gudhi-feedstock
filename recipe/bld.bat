set CMAKE_CONFIG=Release
set CMAKE_GENERATOR=NMake Makefiles

:: Download submodule
git submodule update --init

:: Construct user version from devel version

mkdir build && cd build

echo %CL%
CL=/Zm50

echo cmake -LAH -G"%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" -DWITH_GUDHI_PYTHON=OFF -DUSER_VERSION_DIR=version ..
cmake -LAH -G"%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" -DWITH_GUDHI_PYTHON=OFF -DUSER_VERSION_DIR=version .. || goto :eof

echo cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION
cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION || goto :eof

cd version

:: Build and install user version

mkdir build && cd build

echo cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DBoost_USE_STATIC_LIBS=OFF ^
  -DWITH_GUDHI_PYTHON=OFF ^
  -DWITH_GUDHI_TEST=OFF ^
  -DWITH_GUDHI_UTILITIES=ON ^
  ..
cmake -LAH -G"%CMAKE_GENERATOR%" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DBoost_USE_STATIC_LIBS=OFF ^
  -DWITH_GUDHI_PYTHON=OFF ^
  -DWITH_GUDHI_TEST=OFF ^
  -DWITH_GUDHI_UTILITIES=ON ^
  .. || goto :eof

echo cmake --build . --config %CMAKE_CONFIG% --target INSTALL
cmake --build . --config %CMAKE_CONFIG% --target INSTALL || goto :eof

echo cmake -DPython_EXECUTABLE="%PYTHON%" -DWITH_GUDHI_PYTHON=ON .
cmake -DPython_EXECUTABLE="%PYTHON%" -DWITH_GUDHI_PYTHON=ON . || goto :eof

cd python
echo python setup.py build and install
echo %PYTHON% setup.py build_ext
%PYTHON% setup.py build_ext
echo %PYTHON% -m pip install . -vv
%PYTHON% -m pip install . -vv
