#! /usr/bin/env bash

#  uninstall-opencv.sh

# Remove OpenCV and all dependencies

for package in opencv $(brew deps opencv)
do
  brew rm --ignore-dependencies --force $package
done
