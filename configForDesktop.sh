#!/bin/bash
rm -r build
mkdir build
cd build 
ln -s ./../resources/assets assets
ln -s ./../resources/config config
ln -s ./../resources/sounds sounds