#!/bin/sh

# Update package list and install gdebi
echo "Installing gdebi..."
sudo apt update
sudo apt install -y gdebi

# Define URLs
ADD_APT_KEY_URL="https://github.com/gaining/Resetter/releases/download/v3.0.0-stable/add-apt-key_1.0-0.5_all.deb"
RESETTER_URL="https://github.com/gaining/Resetter/releases/download/v3.0.0-stable/resetter_3.0.0-stable_all.deb"

# Download add-apt-key
echo "Downloading add-apt-key..."
wget "$ADD_APT_KEY_URL" -O add-apt-key.deb

# Install add-apt-key
echo "Installing add-apt-key..."
sudo gdebi add-apt-key.deb

# Download Resetter
echo "Downloading Resetter..."
wget "$RESETTER_URL" -O resetter.deb

# Install Resetter
echo "Installing Resetter..."
sudo gdebi resetter.deb

# Clean up
rm add-apt-key.deb resetter.deb

echo "Resetter installed successfully."
