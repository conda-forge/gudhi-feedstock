set CMAKE_CONFIG="Release"

:: Construct user version from devel version

mkdir build && cd build

cmake -LAH -G"NMake Makefiles" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DUSER_VERSION_DIR=version ^
  ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target USER_VERSION
if errorlevel 1 exit 1

cd version

:: Build and install user version

mkdir build && cd build

:: Rollback to have utilities - begin
:: cmake -LAH -G"NMake Makefiles" ^
::   -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
::   -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
::   -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
::   -DPython_ADDITIONAL_VERSIONS=${PY_VER} ^
::   -DPYTHON_EXECUTABLE="%PYTHON%" ^
::   -DWITH_GUDHI_PYTHON=OFF ^
::   ..
:: if errorlevel 1 exit 1
:: 
:: cmake --build . --config %CMAKE_CONFIG% --target INSTALL
:: if errorlevel 1 exit 1
:: 
:: cmake -DWITH_GUDHI_PYTHON=ON .
:: if errorlevel 1 exit 1
:: 
:: cd python
:: python setup.py install
:: if errorlevel 1 exit 1
:: Rollback to have utilities - end

cmake -LAH -G"NMake Makefiles" ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DPython_ADDITIONAL_VERSIONS=${PY_VER} ^
  -DPYTHON_EXECUTABLE="%PYTHON%" ^
  -DWITH_GUDHI_PYTHON=ON .
if errorlevel 1 exit 1

cd python
python setup.py install
if errorlevel 1 exit 1
