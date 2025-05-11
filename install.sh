#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
apt update && apt upgrade -y

# Install VSCode
echo "Installing VSCode..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' > /etc/apt/sources.list.d/vscode.list
apt update && apt install -y code

# Install Spotify
snap install spotify
#echo "Installing Spotify..."
#curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor #-o /etc/apt/trusted.gpg.d/spotify.gpg
#echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
#apt update && apt install -y spotify-client

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
echo "Installing Draw.io..."
wget -qO /tmp/drawio-amd64.deb https://github.com/jgraph/drawio-desktop/releases/latest/download/drawio-amd64-20.8.16.deb
sudo chmod 777 ./drawio-amd64-20.8.16.deb
apt install -y /tmp/drawio-amd64.deb

# Install Vivado
tar -xvzf ./Vivado2024.2.tar.gz
./Vivado2024.2/xsetup -a XilinxEULA,3rdPartyEULA -b Install -c vivado_2024.2_install_config.txt
echo 'export PATH=//home/ben/xilinx/Vivado/2024.2/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
# Cleanup
rm -rf ./Vivado2024.2

# Install questa
tar -xvzf ./QuestaSetup-24.1std.0.1077-linux.tar.gz
./QuestaSetup-24.1std.0.1077-linux.run --questa_edition questa_fse --accept_eula 1 --installdir /home/ben/altera/24.1std --mode unattended
echo 'export LM_LICENSE_FILE=/home/ben/licenses/LR-233561_License.dat' >> ~/.bashrc
echo 'export PATH=/home/ben/altera/24.1std/questa_fse/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
# Cleanup
rm -rf ./QuestaSetup-24.1std.0.1077-linux.run

echo "All installations completed successfully!"
