#! /usr/bin/env bash

#  install-opencv.sh

libraries="ilmbase snappy lame opencore-amr speex theora rtmpdump x264 x265 rtmpdump openssl libogg libvorbis ffmpeg jpeg libpng libtiff openexr opus"
for package in opencv@2 $libraries; do brew link $package || brew install --ignore-dependencies $package; done


# To remove all dependencies:
# for package in opencv@2 xz $(brew deps opencv@2); do brew rm --ignore-dependencies $package; done
