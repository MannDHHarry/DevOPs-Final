#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Full System Provisioning..."

# 1. Update and install base dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release snapd

# 2. Install Docker
echo "🐳 Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 3. Install Nginx
echo "🌐 Installing Nginx..."
sudo apt-get install -y nginx

# 4. Install Certbot (via Snap - the recommended way for Ubuntu)
echo "🔒 Installing Certbot..."
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot || true

# 5. User Permissions setup
echo "👤 Configuring user permissions..."
sudo groupadd docker || true
sudo usermod -aG docker $USER

echo "-----------------------------------------------"
echo "✅ ALL TOOLS INSTALLED SUCCESSFULLY!"
echo "-----------------------------------------------"
echo "Next Steps:"
echo "1. Run: newgrp docker"
echo "2. Edit your Nginx config for akhdev.site"
echo "3. Run: sudo certbot --nginx -d akhdev.site -d www.akhdev.site"
