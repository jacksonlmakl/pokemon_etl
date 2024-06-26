#!/bin/bash

# Define the image name and version
IMAGE_NAME="my_airflow_image"
IMAGE_VERSION="latest"
CONTAINER_NAME="airflow_container"

# Navigate to the data_flow_tool directory
cd /home/ubuntu/data_flow_tool

# Define the path to the virtual environment
VENV_DIR="/home/ubuntu/data_flow_tool/airflow_venv"

# Define the output file for the requirements
OUTPUT_FILE="/home/ubuntu/data_flow_tool/requirements.txt"

# Check if the virtual environment directory exists
if [ ! -d "$VENV_DIR" ]; then
  echo "Virtual environment directory $VENV_DIR does not exist."
  exit 1
fi

# Check if entry_point.sh exists
if [ ! -f "entry_point.sh" ]; then
  echo "entry_point.sh does not exist in the current directory."
  exit 1
fi

# Make entry_point.sh executable
chmod +x entry_point.sh

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Generate the requirements.txt file
pip freeze > "$OUTPUT_FILE"

# Deactivate the virtual environment
deactivate

echo "Requirements have been saved to $OUTPUT_FILE"

# Remove pkg_resources from requirements.txt if present
sed -i "s/pkg_resources==0.0.0/ /g" $OUTPUT_FILE

# Create a Dockerfile if it doesn't exist
cat <<EOF > Dockerfile
# Use the official Airflow image with Python 3.8
FROM apache/airflow:2.5.1-python3.8

# Set environment variables
ENV AIRFLOW_HOME=/opt/airflow

# Create necessary directories and set permissions
USER root
RUN mkdir -p /opt/airflow/logs /opt/airflow/dags && \
    chown -R airflow: /opt/airflow

# Copy everything from the current directory to the working directory in the Docker image
COPY . /opt/airflow/

# Ensure entry_point.sh is executable
RUN chmod +x /opt/airflow/entry_point.sh

# Switch to the airflow user
USER airflow

# Install dependencies directly as the airflow user
RUN pip install --upgrade pip && \
    pip install -r /opt/airflow/requirements.txt

# Set the working directory
WORKDIR /opt/airflow

# Set the entrypoint
ENTRYPOINT ["/opt/airflow/entry_point.sh"]
EOF

# Build the Docker image
sudo docker build -t $IMAGE_NAME:$IMAGE_VERSION .

# Stop and remove any existing container with the same name
sudo docker rm -f $CONTAINER_NAME || true

# Run the Docker container
sudo docker run -d --name $CONTAINER_NAME -p 8080:8080 $IMAGE_NAME:$IMAGE_VERSION

# Display logs
sudo docker logs -f $CONTAINER_NAME
