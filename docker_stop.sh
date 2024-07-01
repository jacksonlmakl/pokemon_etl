#!/bin/bash
source "airflow_home/airflow_venv/bin/activate"
CONTAINER_NAME=${1:-"airflow_container"}

# Stop the Docker container
sudo docker stop $CONTAINER_NAME

# Remove the Docker container
sudo docker rm $CONTAINER_NAME


# #!/bin/bash
# source "/airflow_venv/bin/activate"
# CONTAINER_NAME=${1:-"airflow_container"}

# # Stop the Docker container
# sudo docker stop $CONTAINER_NAME

# # Remove the Docker container
# sudo docker rm $CONTAINER_NAME

