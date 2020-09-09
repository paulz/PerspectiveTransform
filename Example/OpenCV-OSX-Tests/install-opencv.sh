#! /usr/bin/env bash

#  install-opencv.sh

libraries="openblas tbb gcc"

# due to Warning: Refusing to link macOS-provided software: openblas
# link /usr/local/opt/openblas is not getting restored
ln -s /usr/local/Cellar/openblas/`ls /usr/local/Cellar/openblas` /usr/local/opt/openblas || true

for package in $libraries opencv
do
  brew link $package || brew install --ignore-dependencies --force-bottle $package
done

# To remove all dependencies:
# for package in opencv $(brew deps opencv); do brew rm --ignore-dependencies --force $package; done
