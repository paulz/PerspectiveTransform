#! /usr/bin/env bash

#  install-opencv.sh

libraries="openblas tbb gcc"

for package in $libraries opencv
do
  # due to Warning: Refusing to link macOS-provided software: openblas
  [ $package == openblas ] && check=list || check=link
  brew $check $package || brew install --ignore-dependencies --force-bottle $package
done
