#!/bin/bash

# Exit on any error
set -e


#-----------------------------------------------------------------------------
# CREATE FONT AND THEMES FOLDER IF DON'T EXIST
#-----------------------------------------------------------------------------
echo -e "----------------\nCreating font and themes folders if they don't exist\n----------------"
mkdir -p ~/.themes ~/.fonts

# Update and upgrade
echo -e "----------------\nUpdating and upgrading packages\n----------------"
sudo apt update && sudo apt upgrade -y

#--------------------------------------------------------------
# INSTALL DOCKER https://docs.docker.com/engine/install/ubuntu/
#--------------------------------------------------------------

echo -e "----------------\nInstalling Docker\n----------------"

# Ensure Docker old versions are uninstalled
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

# Remove snap-installed Docker if present
sudo snap remove docker || true

# Install necessary packages
sudo apt-get install -y ca-certificates curl

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list again after adding Docker's repository
sudo apt-get update

# Install the latest version of Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#-----------------------------------------------------------------------------
# DOCKER POSTINSTALL https://docs.docker.com/engine/install/linux-postinstall/
#-----------------------------------------------------------------------------
echo "Docker is now installed. Please follow the postinstall steps at https://docs.docker.com/engine/install/linux-postinstall/"