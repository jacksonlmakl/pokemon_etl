#!/bin/bash
source "airflow_venv/bin/activate"

# Define the image name and version
IMAGE_NAME="jacksonmakl/data_flow_tool"
IMAGE_VERSION="latest"
CONTAINER_NAME="airflow_container"

# Run the Docker container
sudo docker run -d --name $CONTAINER_NAME -p 8080:8080 $IMAGE_NAME:$IMAGE_VERSION
