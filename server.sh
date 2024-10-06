#!/bin/bash

PULL_DIRECTORY="/home/hamster/website/$1/server"
VARIABLES="/home/hamster/variables/$1/.env"

#CREATING PULL DIRECTORY
mkdir -p "$PULL_DIRECTORY"
cd "$PULL_DIRECTORY"

if [ ! -d ".git" ]; then
	git init >/dev/null 2>&1
	git remote add origin "$GITHUB_TOKEN/$1.git" >/dev/null 2>&1
fi

echo -e "\n\n##############################################################\n"
echo -e "Pulling code\n\n"
git pull origin server

cp -f "$VARIABLES" "$PULL_DIRECTORY"

#DEPENDENCIES AND STARTING
echo -e "\n\n##############################################################\n"
echo -e "Installing Dependencies\n\n"
npm i

echo -e "\n\n##############################################################\n"
echo -e "Starting server\n\n"

pm2 describe "$1" > /dev/null

if [ $? -ne 0 ]; then
	pm2 start server.js --name "$1"
else
	pm2 restart "$1"
fi

pm2 save > /dev/null
