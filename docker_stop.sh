#!/bin/bash
source "airflow_venv/bin/activate"
# Define the container name
CONTAINER_NAME="airflow_container"

# Stop the Docker container
sudo docker stop $CONTAINER_NAME

# Remove the Docker container
sudo docker rm $CONTAINER_NAME
