#!/bin/bash

PULL_DIRECTORY="/home/hamster/projects/$1/client"
BUILD_DIRECTORY="/home/hamster/website/$1/client"
VARIABLES="/home/hamster/variables/$1/.env.production.local"

#CREATING PULL DIRECTORY
mkdir -p "$PULL_DIRECTORY"
cd "$PULL_DIRECTORY"

echo "$GITHUB_TOKEN"

if [ ! -d ".git" ]; then
	git init >/dev/null 2>&1
	git remote add origin "$GITHUB_TOKEN/$1.git" >/dev/null 2>&1
fi

echo -e "\n\n##############################################################\n"
echo -e "Pulling code\n\n"
git pull origin client

cp -f "$VARIABLES" "$PULL_DIRECTORY"

#BUILDING FILES
echo -e "\n\n##############################################################\n"
echo -e "Installing Dependencies\n\n"
npm i

echo -e "\n\n##############################################################\n"
echo -e "Building react app\n\n"
./node_modules/.bin/tsc && ./node_modules/.bin/vite build --outDir "$BUILD_DIRECTORY" --emptyOutDir
