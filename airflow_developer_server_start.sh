#!/bin/bash

# airflow_development_server_start.sh

# Get the current working directory
CURRENT_DIR=$(pwd)

# Set AIRFLOW_HOME to current directory
export AIRFLOW_HOME="$CURRENT_DIR/airflow_home"

# Activate the virtual environment
source "$CURRENT_DIR/airflow_venv/bin/activate"

# Start the Airflow webserver
echo "Starting Airflow webserver..."
airflow webserver -p 8082 &

# Start the Airflow scheduler
echo "Starting Airflow scheduler..."
airflow scheduler &

echo "Airflow webserver and scheduler started."

