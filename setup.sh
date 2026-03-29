cat << 'EOF' > setup_lab.sh
#!/bin/bash
set -e

echo "🚀 Starting DevOps Lab Setup for Pranav..."

# 1. Update and Base Essentials
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git vim build-essential apt-transport-https \
ca-certificates software-properties-common gnupg lsb-release net-tools htop \
unzip zip tmux neofetch jq tree python3 python3-pip golang-go nodejs npm

# 2. Docker Installation
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# 3. Terraform Installation
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# 4. Kubernetes (Minikube + Kubectl)
curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb"
sudo dpkg -i minikube_latest_amd64.deb && rm minikube_latest_amd64.deb
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# 5. VS Code Installation
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install -y code && rm packages.microsoft.gpg

# 6. Quality of Life: Aliases & SSH
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
grep -qxF "alias k='kubectl'" ~/.bashrc || echo "alias k='kubectl'" >> ~/.bashrc
grep -qxF "alias d='docker'" ~/.bashrc || echo "alias d='docker'" >> ~/.bashrc
grep -qxF "alias tf='terraform'" >> ~/.bashrc || echo "alias tf='terraform'" >> ~/.bashrc

echo "✅ Lab Setup Complete! Please log out and log back in for Docker group changes to take effect."
EOF
chmod +x setup_lab.sh
./setup_lab.sh
