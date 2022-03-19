#!/bin/bash
set -ex

dockeruser=${1:-$USER}

# Install docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
curl -L "https://get.docker.com" -o "get-docker.sh"
sudo sh get-docker.sh && rm get-docker.sh

# setup current user for docker
sudo usermod -aG docker $dockeruser

#download ta server repository
rm -rf ./taserver
mkdir ./taserver
git clone https://github.com/chickenbellyfin/taserver-deploy.git ./taserver

#create docker image
cd ./taserver/docker
docker image prune --force
docker container prune --force
DOCKER_BUILDKIT=1 docker build . -t taserver

# execute helper script
chmod +x taserver.sh
./taserver.sh -d gamesettings