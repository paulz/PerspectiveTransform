#! /usr/bin/env bash

#  install-opencv.sh

libraries="openblas tbb gcc"

for package in $libraries opencv
do
  brew link $package || brew install --ignore-dependencies --force-bottle $package
done

# To remove all dependencies:
# for package in opencv $(brew deps opencv); do brew rm --ignore-dependencies --force $package; done
