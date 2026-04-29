#!/bin/bash

# 1. Update system and install Java 21 (Required for Jenkins 2.555.1+)
sudo apt-get update
sudo apt-get install -y fontconfig openjdk-21-jre wget apt-transport-https gnupg lsb-release

# 2. Jenkins Installation
# Download the latest keyring and add the repository
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y jenkins
sudo systemctl enable --now jenkins

# 3. Docker Installation & Permissions
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins
# Restart services to apply group changes
sudo systemctl restart docker
sudo systemctl restart jenkins

# 4. Trivy Installation (Modern Repository Method)
# Create keyring directory and import the key securely
sudo mkdir -p /usr/share/keyrings
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

# Add Trivy repository with the signed-by flag
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt-get update
sudo apt-get install -y trivy

# 5. Cloud Tools (AWS CLI & Helm)
sudo apt-get install -y snapd
sudo snap install aws-cli --classic
sudo snap install helm --classic

# Print Versions to confirm success
echo "Installation Complete!"
java -version
jenkins --version
trivy --version
docker --version