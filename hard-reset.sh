#!/bin/sh

sudo docker stop $(sudo docker ps -qa)
sudo docker rm $(sudo docker ps -qa)

sudo docker rmi $(sudo docker images -qa)
sudo docker system prune -fa
sudo docker network prune -f

set -e

sudo docker build -t thesis-app ./services/app/
sudo docker build -t thesis-db ./services/db/
sudo docker build -t vscode ./services/vscode/

sudo docker compose up -d
