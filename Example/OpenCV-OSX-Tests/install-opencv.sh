#! /usr/bin/env bash

#  install-opencv.sh

libraries="tbb openblas gcc ffmpeg libpng libtiff ilmbase openexr jpeg opencore-amr snappy lame openjpeg opus speex theora libogg libvorbis x264 x265 libsoxr libbluray gnutls rtmpdump openssl fontconfig freetype p11-kit libunistring libtasn1 nettle gmp libffi"

for package in opencv $libraries; do brew link $package || brew install --ignore-dependencies --force-bottle $package; done
# due to Warning: Refusing to link macOS-provided software: openblas
# link /usr/local/opt/openblas is not getting restored
ln -s /usr/local/Cellar/openblas/`ls /usr/local/Cellar/openblas` /usr/local/opt/openblas || true

# To remove all dependencies:
# for package in opencv $(brew deps opencv); do brew rm --ignore-dependencies --force $package; done
