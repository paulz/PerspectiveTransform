#! /usr/bin/env bash

#  install-opencv.sh

libraries="openblas tbb gcc"

for package in $libraries opencv
do
  brew link $package || brew install --ignore-dependencies --force-bottle $package
done

# due to Warning: Refusing to link macOS-provided software: openblas
# link /usr/local/opt/openblas is not getting restored
cellar=$(brew --prefix)/Cellar/openblas
ln -s $cellar/`ls $cellar` $(brew --prefix openblas) || true
