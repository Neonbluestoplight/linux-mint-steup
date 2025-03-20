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
echo -e "----------------\nAdding user to Docker group\n----------------"
sudo groupadd docker || true
sudo usermod -aG docker $USER

# Inform the user about new group changes
echo -e "You need to log out and log back in to apply the group changes."

# Start a new group session (optional; user may need to log out)
newgrp docker || true

echo -e "----------------\nChecking Docker installation\n----------------"
docker run hello-world || { echo "Docker installation failed. Please check the output above."; exit 1; }

echo "Do you see the hello world message from Docker? (yes/no)"
read input
if [[ "$input" == "yes" ]]; then
  echo "Please reboot your computerContinuing....."
else
  echo "Exiting due to failure to see Docker message."
  exit 1
fi

# Configure Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service