#!/bin/bash

# 1. Update system and install Java 21
# Jenkins requires Java; OpenJDK 21 is the current standard for Jenkins 2.555.1+
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre 

# 2. Jenkins Installation
# Ensure the keyring directory exists
sudo mkdir -p /etc/apt/keyrings

# Download the 2026 Jenkins GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Add the signed repository to your sources
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update repository list and install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start and enable Jenkins service
sudo systemctl enable jenkins

# 3. Docker Installation & Permissions
# Installing docker.io and setting permissions for the Jenkins user
sudo apt install -y docker.io
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Restart services to apply group changes
sudo systemctl restart docker
sudo systemctl restart jenkins

# Final output for ease of use
echo "-------------------------------------------------------"
echo "Jenkins installation complete!"
echo "Access the UI at: http://$(hostname -I | awk '{print $1}'):8080"
echo "Your initial Admin Password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "-------------------------------------------------------"