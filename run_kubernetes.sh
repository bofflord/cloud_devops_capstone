#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=boffmasta/ml-app:latest

# Step 2
#docker login
cat dockertoken.txt | docker login --username boffmasta --password-stdin
# Run the Docker Hub container with kubernetes
kubectl run ml-app --image=$dockerpath --port=80

# Step 3:
# List kubernetes pods
kubectl get pods
# Wait for until pod is running
while [[ $(kubectl get pods ml-app -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 1; done
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
#kubectl expose deployment ml-app --port=8080 --target-port=80
kubectl port-forward pod/ml-app 8000:80
