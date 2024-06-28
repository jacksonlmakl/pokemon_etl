#!/bin/bash

# airflow_start.sh

# Get the current working directory
CURRENT_DIR=$(pwd)

# Set AIRFLOW_HOME to current directory
export AIRFLOW_HOME="$CURRENT_DIR/airflow_home"

# Activate the virtual environment
source "$CURRENT_DIR/airflow_venv/bin/activate"

# Find every requirements.txt file in the dags directory and its subdirectories
find dags -name 'requirements.txt' | while read requirements_file; do
    echo "Installing packages from $requirements_file"
    pip install -r "$requirements_file"
done


# Start the Airflow webserver
echo "Starting Airflow webserver..."
airflow webserver -p 8080 &

# Start the Airflow scheduler
echo "Starting Airflow scheduler..."
airflow scheduler &

echo "Airflow webserver and scheduler started."

