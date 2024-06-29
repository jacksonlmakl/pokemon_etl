#!/bin/bash

IMAGE_NAME=${1:-"jacksonmakl/data_flow_tool"}
IMAGE_VERSION=${2:-"latest"}
CONTAINER_NAME=${3:-"airflow_container"}

# Navigate to the data_flow_tool directory
cd data_flow_tool

# Define the path to the virtual environment
VENV_DIR="airflow_venv"

# Define the output file for the requirements
OUTPUT_FILE="requirements.txt"

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
sudo source "$VENV_DIR/bin/activate"

# Find every requirements.txt file in the dags directory and its subdirectories
find dags -name 'requirements.txt' | while read requirements_file; do
    echo "Installing packages from $requirements_file"
    pip install -r "$requirements_file"
done

# Generate the requirements.txt file
pip freeze > "$OUTPUT_FILE"

# Deactivate the virtual environment
deactivate

echo "Requirements have been saved to $OUTPUT_FILE"

# Remove pkg_resources from requirements.txt if present
sed -i "s/pkg_resources==0.0.0/ /g" $OUTPUT_FILE
sed -i "s/dbt-snowflake/ /g" "--no-cache-dir dbt-snowflake"
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

# Install python3.8-venv if it's not installed
USER root
RUN python3 -m venv "/opt/airflow/airflow_venv"
RUN source /opt/airflow/airflow_venv/bin/activate

# Install dependencies directly as the airflow user
RUN pip3  install --upgrade pip && \
    pip3  install -r /opt/airflow/requirements.txt
USER airflow
# Set the working directory
WORKDIR /opt/airflow

# Set the entrypoint
ENTRYPOINT ["/opt/airflow/entry_point.sh"]
EOF

# Build the Docker image
sudo docker build -t $IMAGE_NAME:$IMAGE_VERSION .

# Stop and remove any existing container with the same name
sudo docker rm -f $CONTAINER_NAME || true
echo "Docker Image Built Successfully"
exit 0


# #!/bin/bash

# IMAGE_NAME=${1:-"jacksonmakl/data_flow_tool"}
# IMAGE_VERSION=${2:-"latest"}
# CONTAINER_NAME=${3:-"airflow_container"}

# # Navigate to the data_flow_tool directory
# cd data_flow_tool

# # Define the path to the virtual environment
# VENV_DIR="airflow_venv"

# # Define the output file for the requirements
# OUTPUT_FILE="requirements.txt"

# # Check if the virtual environment directory exists
# if [ ! -d "$VENV_DIR" ]; then
#   echo "Virtual environment directory $VENV_DIR does not exist."
#   exit 1
# fi

# # Check if entry_point.sh exists
# if [ ! -f "entry_point.sh" ]; then
#   echo "entry_point.sh does not exist in the current directory."
#   exit 1
# fi

# # Make entry_point.sh executable
# chmod +x entry_point.sh

# # Activate the virtual environment
# source "$VENV_DIR/bin/activate"

# # Find every requirements.txt file in the dags directory and its subdirectories
# find dags -name 'requirements.txt' | while read requirements_file; do
#     echo "Installing packages from $requirements_file"
#     pip install -r "$requirements_file"
# done

# # Generate the requirements.txt file
# pip freeze > "$OUTPUT_FILE"

# # Deactivate the virtual environment
# deactivate

# echo "Requirements have been saved to $OUTPUT_FILE"

# # Remove pkg_resources from requirements.txt if present
# sed -i "s/pkg_resources==0.0.0/ /g" $OUTPUT_FILE

# # Create a Dockerfile if it doesn't exist
# cat <<EOF > Dockerfile
# # Use the official Airflow image with Python 3.8
# FROM apache/airflow:2.5.1-python3.8

# # Set environment variables
# ENV AIRFLOW_HOME=/opt/airflow

# # Create necessary directories and set permissions
# USER root
# RUN mkdir -p /opt/airflow/logs /opt/airflow/dags && \
#     chown -R airflow: /opt/airflow

# # Copy everything from the current directory to the working directory in the Docker image
# COPY . /opt/airflow/

# # Ensure entry_point.sh is executable
# RUN chmod +x /opt/airflow/entry_point.sh

# # Switch to the airflow user
# USER airflow

# # Install dependencies directly as the airflow user
# RUN pip install --upgrade pip && \
#     pip install -r /opt/airflow/requirements.txt

# # Set the working directory
# WORKDIR /opt/airflow

# # Set the entrypoint
# ENTRYPOINT ["/opt/airflow/entry_point.sh"]
# EOF

# # Build the Docker image
# sudo docker build -t $IMAGE_NAME:$IMAGE_VERSION .

# # Stop and remove any existing container with the same name
# sudo docker rm -f $CONTAINER_NAME || true
# echo "Docker Image Built Successfully"
# exit 0