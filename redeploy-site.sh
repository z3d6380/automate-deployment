#!/usr/bin/env bash

# File: redeploy-site.sh
# Written By: Luis Moraguez
# Description: Automates the process of redeploying a Flask site

# Kill all tmux sessions
pkill -f tmux

# cd into project directory
cd ~/flask-portfolio-site

# Make sure local git repo has the latest changes from main branch on GitHub
git fetch --all && git pull origin main

# Enter python virtual environment and install python dependencies using requirements.txt
python -m venv python3-virtualenv
source python3-virtualenv/bin/activate
# pip install --upgrade pip # May be needed in some cases
pip install -r requirements.txt

# Start Detached tmux session that enters project directory, enters python virtual environment, starts the Flask server
tmux new -d -s flask 'cd ~/flask-portfolio-site && source python3-virtualenv/bin/activate && flask run --host=0.0.0.0; exec $SHELL'
