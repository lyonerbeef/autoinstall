#!/bin/bash

# Create a temporary installation folder
INSTALL_DIR="/tmp/install"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

# Update and upgrade the system
echo "Updating and upgrading the system..."
apt update && apt upgrade -y

# Install VSCode
echo "Installing VSCode..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' > /etc/apt/sources.list.d/vscode.list
apt update && apt install -y code

# Install Spotify
echo "Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
apt update && apt install -y spotify-client

# Install Docker
echo "Installing Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  apt-get remove -y $pkg
done
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
apt update && apt install -y docker-ce docker-ce-cli containerd.io

# Install Draw.io
#echo "Installing Draw.io..."
#wget -qO /tmp/drawio-amd64.deb https://github.com/jgraph/drawio-desktop/releases/latest/download/drawio-amd64-20.8.16.deb
#sudo chmod 777 ./drawio-amd64-20.8.16.deb
#apt install -y /tmp/drawio-amd64.deb

# Cleanup
cd /
echo "Cleaning up installation files..."
rm -rf "$INSTALL_DIR"

echo "All installations completed successfully!"
