#! /usr/bin/env bash

#  install-opencv.sh

libraries="openblas tbb gcc"

for package in $libraries opencv
do
  brew list $package > /dev/null || brew install --ignore-dependencies --force-bottle $package
done

brew link opencv
