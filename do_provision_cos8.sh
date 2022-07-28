#!/usr/bin/env bash

# File: do_provision_cos8.sh
# Written By: Luis Moraguez
# Description: Provisions a DigitalOcean Droplet that is running Centos Stream 8
# Usage: ./do_provision_cos8.sh

# Update OS
dnf update -y

# Install Python
dnf install -y git python3
ln -fs $(which python3) /usr/bin/python

# Install Nano text editor
dnf install -y nano

# Install TMUX
dnf install -y tmux

# Git Clone Flask App Repo
git clone https://github.com/z3d6380/flask-portfolio-site

# Enter Repo
cd ~/flask-portfolio-site

# Install python virtual environment
python -m venv python3-virtualenv

# Enter python virtual environment
source python3-virtualenv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install python dependencies
pip install -r requirements.txt

# Deactivate virtual environment
deactivate

# Install Docker
curl -sSL https://get.docker.com/ | sudo sh
sudo systemctl start docker
sudo systemctl enable docker

# Download redeploy script
curl -L https://raw.githubusercontent.com/z3d6380/automate-deployment/main/redeploy-site.sh > ~/redeploy-site.sh && chmod 750 ~/redeploy-site.sh

# Run redeploy script
~/redeploy-site.sh
