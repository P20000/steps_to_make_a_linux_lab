Perfect — that’s the right move. Instead of running random tools all over your Windows system, you’re building a **dedicated Linux lab** — exactly how professionals work.

We’ll turn your Ubuntu VirtualBox setup into a **modular DevOps + Cloud lab** with clean, reproducible environments for **Docker, Kubernetes, Terraform, CI/CD, and automation testing** — all running efficiently on your laptop.

Let’s build it *properly* from the ground up — the way a senior DevOps engineer would.

---

## 🧠 OVERVIEW — What We’re Building

Your VM (Ubuntu) will become a **self-contained Linux playground** with:

* ✅ Docker & Docker Compose
* ✅ Kubernetes (via Minikube or Kind)
* ✅ Terraform
* ✅ Git + VS Code + CLI essentials
* ✅ SSH access
* ✅ Snapshot management (so you can rollback anytime)
* ✅ Optional: Python + Go + Node.js (for scripting / infra tools)

---

## ⚙️ STEP 1 — Finalize VirtualBox Hardware Setup

Since your host is strong (i5-12450H, 16 GB RAM, SSD):

* **RAM:** 6 GB (6144 MB)
* **vCPUs:** 4
* **Video Memory:** 128 MB
* **3D Acceleration:** Enabled
* **Disk:** 50 GB Fixed-size VDI (SSD)
* **Network Adapter:** Bridged (so you can access the VM from Windows directly via IP)
* **Host I/O cache:** Enabled

> 💡 Snapshot right now and name it: **“Fresh Ubuntu Base”** — so you can revert later if needed.

---

## 🧩 STEP 2 — Base Ubuntu Setup

Once booted into Ubuntu, update everything:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget git vim build-essential apt-transport-https ca-certificates software-properties-common gnupg lsb-release -y
```

Set the hostname:

```bash
sudo hostnamectl set-hostname linux-lab
```

Then reboot:

```bash
sudo reboot
```

---

## 🐳 STEP 3 — Install Docker + Docker Compose

```bash
sudo apt remove docker docker-engine docker.io containerd runc -y
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USER
newgrp docker
```

Verify:

```bash
docker run hello-world
```

---

## ☸️ STEP 4 — Install Kubernetes (Minikube + kubectl)

We’ll use **Minikube** (lightweight local K8s) — ideal for VirtualBox.

```bash
curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb"
sudo dpkg -i minikube_latest_amd64.deb
sudo apt install conntrack -y

# Install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Start cluster
minikube start --driver=docker
```

> 💡 You can check with:
> `kubectl get nodes`
> You’ll see your local cluster up and ready.

---

## 🌍 STEP 5 — Install Terraform

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
terraform -version
```

---

## 🧰 STEP 6 — Developer Utilities (recommended)

```bash
sudo apt install net-tools htop unzip zip tmux neofetch jq tree -y
```

**VS Code (optional but powerful):**

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install apt-transport-https
sudo apt update
sudo apt install code -y
```

---

## 🧱 STEP 7 — Optional: Add Programming Languages

For scripting and automation:

```bash
sudo apt install python3 python3-pip golang-go nodejs npm -y
```

---

## 🧩 STEP 8 — Quality-of-Life Tweaks

* Enable **SSH Server** (so you can SSH from Windows):

  ```bash
  sudo apt install openssh-server -y
  sudo systemctl enable ssh
  sudo systemctl start ssh
  ip addr show
  ```

  → Copy the IP to connect from PuTTY or Windows Terminal.

* Create aliases:

  ```bash
  echo "alias k='kubectl'" >> ~/.bashrc
  echo "alias tf='terraform'" >> ~/.bashrc
  echo "alias d='docker'" >> ~/.bashrc
  source ~/.bashrc
  ```

---

## 📦 STEP 9 — Snapshots for Safety

Once everything’s working smoothly:

* In VirtualBox → Take snapshot → Name it:
  **“DevOps Stack Installed – Stable”**

So if you ever break Docker/K8s/Terraform, one click brings it back.

---

## 🧠 STEP 10 — Workflow Example

You can now:

* Write Terraform IaC files in `/projects/infra`
* Deploy containers via Docker Compose or Minikube
* Test automation scripts in isolation
* Use Git for version control

  ```bash
  git config --global user.name "Pranav Dwivedi"
  git config --global user.email "you@example.com"
  ```

---

Would you like me to make a **setup script** (`setup_devops_lab.sh`) that installs everything automatically in one go?
You could just copy-paste one command into Ubuntu and have your entire DevOps lab ready in 5–10 minutes.
