#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and install prerequisites
echo "Updating system and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# Verify Docker installation
if [[ $(docker --version) ]]; then
    echo "Docker installed successfully: $(docker --version)"
else
    echo "Docker installation failed."
    exit 1
fi

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
if [[ $(docker-compose --version) ]]; then
    echo "Docker Compose installed successfully: $(docker-compose --version)"
else
    echo "Docker Compose installation failed."
    exit 1
fi

# Install Nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx

# Verify Nginx installation
if [[ $(nginx -v 2>&1) ]]; then
    echo "Nginx installed successfully: $(nginx -v 2>&1)"
else
    echo "Nginx installation failed."
    exit 1
fi

echo "All installations completed successfully."
