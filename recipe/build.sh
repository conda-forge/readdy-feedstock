#!/bin/bash

mkdir -p build
cd build || true

export HDF5_ROOT=${PREFIX}

# On macOS, force C++17 to avoid C++20/SDK compatibility issues
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$(uname)" == "Darwin" ]]; then
  CXX_STANDARD="-DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=OFF"
  export CXXFLAGS="$CXXFLAGS -std=c++17"
  export CPPFLAGS="$CPPFLAGS -std=c++17"
else
  CXX_STANDARD=""
fi

cmake .. ${CMAKE_ARGS} \
  -DPYTHON_EXECUTABLE="${PYTHON}" \
  -DPYTHON_PREFIX="${PREFIX}" \
  -DPython_EXECUTABLE="${PYTHON}" \
  -DPython_ROOT_DIR="${PREFIX}" \
  -DPYBIND11_FINDPYTHON=ON \
  -DHDF5_INCLUDE_DIRS="${PREFIX}/include" \
  -DREADDY_CREATE_TEST_TARGET:BOOL=OFF \
  -DREADDY_INSTALL_UNIT_TEST_EXECUTABLE:BOOL=OFF \
  -DREADDY_VERSION=${PKG_VERSION} \
  -DREADDY_BUILD_STRING=${PKG_BUILDNUM} \
  -DSP_DIR="${SP_DIR}" \
  -DIGNORE_VENDORED_DEPENDENCIES:BOOL=ON \
  ${CXX_STANDARD} \
  -GNinja

ninja -j${CPU_COUNT}
ninja install

