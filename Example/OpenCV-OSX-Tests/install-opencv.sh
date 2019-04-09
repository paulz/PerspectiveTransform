#! /usr/bin/env bash

#  install-opencv.sh

libraries="tbb openblas gcc ffmpeg libpng libtiff ilmbase openexr jpeg opencore-amr snappy lame opus speex theora libogg libvorbis x264 x265 rtmpdump openssl libsoxr openjpeg libbluray gnutls p11-kit libunistring libffi gmp nettle libtasn1"

for package in opencv $libraries; do brew link $package || brew install --ignore-dependencies --force-bottle $package; done

# To remove all dependencies:
# for package in opencv $(brew deps opencv); do brew rm --ignore-dependencies --force $package; done
