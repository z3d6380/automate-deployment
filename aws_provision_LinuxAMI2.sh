#!/usr/bin/env sh

# File: aws_provision_LinuxAMI2.sh
# Written By: Luis Moraguez
# Date: 12/22/2022
# Description: Will fully provision an AWS Linux AMI 2 with updates, ntp, git, timezone, automatic updates via cron (and logging),
#              set python3 as primary, upgrade pip, install docker and docker-compose
# Usage: Place script in 'User Data' when deplying an AWS EC2 instance, or manually enter each command yourself via SSH to the EC2 instance

# Update system, install git and ntp, and set timezone
yum update -y && yum install -y git && yum install -y ntp && timedatectl set-timezone America/New_York

# Create logging folder in /root
cd /root || return
mkdir log

# Create cronjob for automatic updates with logging
crontab -l > file; echo "0 0,12 * * * cd /root && yum update -y > /root/log/update.log 2>&1 &" >> file; crontab file; rm file

# Generate ssh key, and updates ec2-user's .bash_profile so that ssh-agent will always add the ssh identity at login. The public key can be added to your GitHub repo/profile so that you can push/pull to repo
sudo -u ec2-user ssh-keygen -t ed25519 -f /home/ec2-user/.ssh/sshkey -q -N ""
{ echo -e "\n\n# At login, run ssh-agent and add ssh-key\n"; echo -e "eval \"\$(ssh-agent -s)\""; echo -e "ssh-add ~/.ssh/sshkey\n"; echo -e "echo -e \"Make sure to copy this public key where it is needed:\"\ncat ~/.ssh/sshkey.pub"; echo -e "# At logout, kill ssh-agent\n"; echo -e "trap 'test -n \"\$SSH_AGENT_PID\" && eval \$(/usr/bin/ssh-agent -k)' 0"; } >> /home/ec2-user/.bash_profile

# Removes current symbolic link to python2
rm /usr/bin/python

# Creates symbolic link to python3
ln -s /usr/bin/python3 /usr/bin/python

# Fixes yum and urlgrabber since they explicitly rely on python2
export PY2_HEADER='\#!\/usr\/bin\/python2'
sed -i.bak "1s/.*/$PY2_HEADER/" /usr/bin/yum
sed -i.bak "1s/.*/$PY2_HEADER/" /usr/libexec/urlgrabber-ext-down

# Installs pip3
yum install python3-pip

# Upgrades pip3
yes | pip3 install --upgrade pip

# Installs Docker
yum install -y docker

# Adds ec2-user to docker group
usermod -a -G docker ec2-user

# Installs docker-compose
yes | pip3 install docker-compose

# Starts and enables docker service
systemctl enable docker.service
systemctl start docker.service
