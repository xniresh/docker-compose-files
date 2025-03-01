#!/bin/bash

# Docker and Docker Compose Installation Script for Ubuntu 22.04
# Based on DigitalOcean guides

# Exit immediately if a command exits with a non-zero status
set -e

# Print commands before executing them
set -x

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Docker is already installed
if command_exists docker; then
    echo "Docker is already installed. Checking version..."
    docker --version
    read -p "Do you want to proceed with reinstallation? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping Docker installation."
        exit 0
    fi
fi

echo "Updating package index..."
sudo apt update

echo "Installing prerequisites..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

echo "Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Setting up the Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index with Docker repository..."
sudo apt update

echo "Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Adding current user to the docker group..."
sudo usermod -aG docker ${USER}

# Docker Compose is now installed via docker-compose-plugin
echo "Docker Compose is installed via docker-compose-plugin"

echo "Verifying Docker installation..."
sudo docker run hello-world

echo "Verifying Docker Compose installation..."
docker compose version

echo "Installation complete!"
echo "NOTE: You may need to log out and back in for the group membership changes to take effect."
echo "To use Docker without sudo, run: newgrp docker"