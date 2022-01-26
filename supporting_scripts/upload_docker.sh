#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
dockerpath=boffmasta/ml-app:latest

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
#docker login -u boffmasta
cat dockertoken.txt | docker login --username boffmasta --password-stdin
docker image tag ml-app-local:latest $dockerpath

# Step 3:
# Push image to a docker repository
docker image push $dockerpath