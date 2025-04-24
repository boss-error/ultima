#!/bin/sh


https://github.com/gaining/Resetter/releases/download/v3.0.0-stable/add-apt-key_1.0-0.5_all.deb


sudo dpkg -i add-apt-key_1.0-0.5_all.deb

wget https://github.com/gaining/Resetter/releases/download/v3.0.0-stable/resetter_3.0.0-stable_all.deb
sudo dpkg -i resetter_3.0.0-stable_all.deb

sudo resetter
