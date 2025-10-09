#!/bin/bash
# Install libjpeg-turbo into ~/.local if not already present.
set -euo pipefail
module load cmake/3.30.3-fasrc01 || true

PREFIX=${PREFIX:-$HOME/.local}
VERSION=${VERSION:-3.0.1} # override by: VERSION=3.0.1 ./install_libjpegturbo.sh
SRCDIR=/tmp/libjpeg-turbo-${VERSION}

# --- Skip if installed ---
if pkg-config --exists turbojpeg 2>/dev/null; then
  echo "✔ libjpeg-turbo already installed at $(pkg-config --variable=prefix turbojpeg)"
  exit 0
fi

echo "⏳ Installing libjpeg-turbo ${VERSION} to ${PREFIX}"

cd /tmp
wget -c https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-${VERSION}.tar.gz
tar -xzf libjpeg-turbo-${VERSION}.tar.gz
cd ${SRCDIR}

mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_STATIC=FALSE \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib \
      ..
make -j"$(nproc)"
make install

cd /tmp && rm -rf ${SRCDIR}*

echo "✅ libjpeg-turbo installed to $PREFIX"
echo "Add to ~/.bashrc:"
echo "export LD_LIBRARY_PATH=\$HOME/.local/lib:\$LD_LIBRARY_PATH"
