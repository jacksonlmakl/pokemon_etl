#!/bin/bash

CONTAINER_NAME=${1:-"airflow_container"}

# Define the image name and version
IMAGE_NAME=${2:-"jacksonmakl/data_flow_tool"}
IMAGE_VERSION=${3:-"latest"}

# Check if the container exists
container_exists=$(sudo docker ps -a --format "{{.Names}}" | grep -w $CONTAINER_NAME)

if [ -z "$container_exists" ]; then
  echo "Container $CONTAINER_NAME does not exist. Creating a new container."
  sudo docker run -d --name $CONTAINER_NAME -p 8080:8080 $IMAGE_NAME:$IMAGE_VERSION
else
  echo "Container $CONTAINER_NAME exists. Starting the container."
  sudo docker start $CONTAINER_NAME
fi
