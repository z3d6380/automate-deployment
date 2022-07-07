#!/usr/bin/env bash

# File: redeploy-site.sh
# Written By: Luis Moraguez
# Description: Automates the process of redeploying a Flask site

# cd into project directory
cd ~/flask-portfolio-site

# Make sure local git repo has the latest changes from main branch on GitHub
git fetch --all && git pull origin main

# Restart docker containers
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d --build
