#! /usr/bin/env bash

#  uninstall-opencv.sh

# To remove all dependencies:
for package in opencv $(brew deps opencv)
do
  brew rm --ignore-dependencies --force $package
done
