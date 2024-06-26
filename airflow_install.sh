#!/bin/bash

# install_airflow.sh
AIRFLOW_VERSION=2.5.1
PYTHON_VERSION=3.8
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

# Get the current working directory
CURRENT_DIR=$(pwd)

# Create a virtual environment in the current directory
python3 -m venv "$CURRENT_DIR/airflow_venv"

# Activate the virtual environment
source "$CURRENT_DIR/airflow_venv/bin/activate"

# Upgrade pip
pip install --upgrade pip

# Install Apache Airflow
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Initialize the Airflow database
"$CURRENT_DIR/airflow_venv/bin/airflow" db init

# Create an admin user with username 'admin' and password 'admin'
"$CURRENT_DIR/airflow_venv/bin/airflow" users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin

# Create the dags folder in the current directory
mkdir -p "$CURRENT_DIR/dags"

echo "Airflow installation completed. Admin user created with username 'admin' and password 'admin'."
echo "Airflow dags directory created in $CURRENT_DIR/dags"
echo "Remember to activate your virtual environment with 'source $CURRENT_DIR/airflow_venv/bin/activate' before using Airflow."
