#!/bin/bash

# Set the timezone to Asia/Jakarta
sudo timedatectl set-timezone Asia/Jakarta

# Update and upgrade packages
sudo apt-get update
sudo apt-get upgrade -y

# Install Git, Curl, ZIP, Python3, and Python3-pip
sudo apt-get install -y git curl zip python3 python3-pip

# Install Docker
sudo apt-get install -y docker.io

# Cheat Docker
sudo chmod 777 /var/run/docker.sock

# Display installed versions
echo "Current Timezone: $(timedatectl | grep 'Time zone')"
echo "Installed versions:"
echo "Git: $(git --version)"
echo "Curl: $(curl --version | head -n 1)"
echo "ZIP: $(zip --version | head -n 1)"
echo "Python3: $(python3 --version)"
echo "pip3: $(pip3 --version)"
echo "Docker: $(docker --version)"

# install Docker Compose
# sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
# echo "Docker Compose: $(docker-compose --version)"
