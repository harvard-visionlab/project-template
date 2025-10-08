#!/bin/bash
# This script installs libjpegturbo for your user on the cluster (notice the $HOME/.local location).
# You only need to run this once, ever, and it will be availble in all your envs.
# In this template, libjpegturbo is used by the PyTurboJPEG package, enabling fast jpeg decoding.
set -e  # Exit on error

# Load compatible cmake version (not the 4.x default)
module load cmake/3.30.3-fasrc01

# Install libjpeg-turbo to user prefix
PREFIX=$HOME/.local

cd /tmp
wget -c https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-3.0.1.tar.gz
tar -xzf libjpeg-turbo-3.0.1.tar.gz
cd libjpeg-turbo-3.0.1

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=RELEASE \
      -DENABLE_STATIC=FALSE \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib \
      ..
make -j$(nproc)
make install

cd /tmp && rm -rf libjpeg-turbo-3.0.1*

echo "libjpeg-turbo installed to $PREFIX"
echo "Add this to your ~/.bashrc if not already there:"
echo "export LD_LIBRARY_PATH=\$HOME/.local/lib:\$LD_LIBRARY_PATH"