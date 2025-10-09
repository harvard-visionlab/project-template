#!/usr/bin/env bash
# Minimal OpenCV build (core,imgproc,imgcodecs) into ~/.local with correct pkg-config placement.
# Usage:
#   ./install_opencv.sh                 # install if missing or wrong version
#   ./install_opencv.sh --force         # remove existing OpenCV under $PREFIX and reinstall
#   OPENCV_VERSION=4.6.0 ./install_opencv.sh
#   PREFIX=/n/netscratch/alvarez_lab/Lab/libs ./install_opencv.sh

set -euo pipefail

# ---- Config ----
OPENCV_VERSION="${OPENCV_VERSION:-4.10.0}"
PREFIX="${PREFIX:-$HOME/.local}"
BUILD_LIST="${BUILD_LIST:-core,imgproc,imgcodecs}"
NPROC="${NPROC:-$( (command -v nproc >/dev/null && nproc) || (sysctl -n hw.ncpu 2>/dev/null) || echo 4)}"
FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1
[[ "${FORCE:-0}" = "1" ]] && echo "⚠️  FORCE REINSTALL enabled; existing OpenCV under ${PREFIX} will be removed."

# ---- Modules (adjust to cluster) ----
module load gcc/9.5.0-fasrc01 || true
module load cmake/3.30.3-fasrc01 || true

# ---- Paths ----
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

# ---- Helper: cleanup any existing OpenCV under PREFIX only ----
cleanup_opencv_prefix() {
  echo "🧹 Cleaning previous OpenCV under ${PREFIX} ..."
  # pkg-config file(s)
  rm -f "${PREFIX}/lib/pkgconfig/opencv4.pc" || true
  rm -f "${PREFIX}/lib64/pkgconfig/opencv4.pc" || true

  # CMake package dirs
  rm -rf "${PREFIX}/lib/cmake/opencv4" || true
  rm -rf "${PREFIX}/lib64/cmake/opencv4" || true
  rm -rf "${PREFIX}/share/opencv4" || true

  # Headers
  rm -rf "${PREFIX}/include/opencv4" || true

  # Libraries (be precise: only libopencv_* and versioned symlinks)
  find "${PREFIX}/lib"    -maxdepth 1 -type f -name 'libopencv_*' -print -exec rm -f {} \; || true
  find "${PREFIX}/lib"    -maxdepth 1 -type l -name 'libopencv_*' -print -exec rm -f {} \; || true
  find "${PREFIX}/lib64"  -maxdepth 1 -type f -name 'libopencv_*' -print -exec rm -f {} \; || true
  find "${PREFIX}/lib64"  -maxdepth 1 -type l -name 'libopencv_*' -print -exec rm -f {} \; || true
}

# ---- Skip if already installed (unless --force) ----
if pkg-config --exists opencv4 2>/dev/null; then
  INSTALLED_VER="$(pkg-config --modversion opencv4 || echo unknown)"
  INSTALLED_PREFIX="$(pkg-config --variable=prefix opencv4 || echo unknown)"
  if [[ "$FORCE" -ne 1 && "$INSTALLED_VER" == "$OPENCV_VERSION" && "$INSTALLED_PREFIX" == "$PREFIX" ]]; then
    echo "✔ OpenCV ${INSTALLED_VER} already installed at ${INSTALLED_PREFIX}. Nothing to do."
    exit 0
  fi
  # If version or prefix mismatch and not forcing, proceed to rebuild (will overwrite files in PREFIX)
  if [[ "$FORCE" -eq 1 ]]; then
    cleanup_opencv_prefix
  else
    echo "↻ Reinstalling OpenCV (found ${INSTALLED_VER} at ${INSTALLED_PREFIX}, target ${OPENCV_VERSION} at ${PREFIX})"
  fi
fi

# ---- Build ----
WORKDIR="$(mktemp -d /tmp/opencv-build-XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR"

echo "⏳ Downloading OpenCV ${OPENCV_VERSION} ..."
curl -fsSL -o opencv.tar.gz "https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VERSION}.tar.gz"
tar -xzf opencv.tar.gz
cd "opencv-${OPENCV_VERSION}"
mkdir -p build && cd build

# Key flags:
#  - CMAKE_INSTALL_LIBDIR=lib -> avoid lib64
#  - OPENCV_PKGCONFIG_INSTALL_PATH -> ensure opencv4.pc ends up in PREFIX/lib/pkgconfig
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DOPENCV_GENERATE_PKGCONFIG=ON \
  -DOPENCV_PKGCONFIG_INSTALL_PATH="${PREFIX}/lib/pkgconfig" \
  -DBUILD_LIST="${BUILD_LIST}" \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_opencv_python_bindings_generator=OFF \
  -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF \
  -DWITH_QT=OFF -DWITH_GTK=OFF -DWITH_IPP=OFF -DWITH_TBB=OFF \
  -DWITH_FFMPEG=OFF -DWITH_OPENCL=OFF -DWITH_EIGEN=OFF \
  -DWITH_GSTREAMER=OFF -DWITH_1394=OFF -DWITH_V4L=OFF \
  -DWITH_OPENEXR=OFF -DWITH_TIFF=ON -DWITH_JPEG=ON -DWITH_PNG=ON

make -j"${NPROC}"
make install

# ---- Verify & friendly output ----
echo "✅ OpenCV ${OPENCV_VERSION} installed to ${PREFIX}"
echo "   pkg-config file: ${PREFIX}/lib/pkgconfig/opencv4.pc"
echo
echo "Quick checks:"
echo "  pkg-config --modversion opencv4"
echo "  pkg-config --cflags opencv4"
echo "  pkg-config --libs   opencv4"
echo
echo "If your shell startup doesn’t already include them, add:"
echo "  export PKG_CONFIG_PATH=\$HOME/.local/lib/pkgconfig:\$PKG_CONFIG_PATH"
echo "  export LD_LIBRARY_PATH=\$HOME/.local/lib:\$LD_LIBRARY_PATH"
