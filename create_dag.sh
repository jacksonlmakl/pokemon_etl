#!/bin/bash

# create_dag.sh
DAG_NAME=$1

if [ -z "$DAG_NAME" ]; then
  echo "Usage: ./create_dag.sh <DAG_NAME>"
  exit 1
fi

# Get the current working directory
CURRENT_DIR=$(pwd)

# Create DAG folder
mkdir -p "$CURRENT_DIR/dags/$DAG_NAME/scripts"

# Copy template files to new DAG folder
cp "$CURRENT_DIR/template_folder/configuration.yaml" "$CURRENT_DIR/dags/$DAG_NAME/"
cp "$CURRENT_DIR/template_folder/requirements.txt" "$CURRENT_DIR/dags/$DAG_NAME/"
cp "$CURRENT_DIR/template_folder/scripts/"* "$CURRENT_DIR/dags/$DAG_NAME/scripts/"

# Replace placeholder name in configuration.yaml with the DAG name
sed -i "s/<PLACEHOLDER_NAME_HERE>/$DAG_NAME/g" "$CURRENT_DIR/dags/$DAG_NAME/configuration.yaml"
sed -i "s/name: \".*\"/name: \"$DAG_NAME\"/" "$CURRENT_DIR/dags/$DAG_NAME/configuration.yaml"

# Copy the template DAG to the new DAG folder
cp "$CURRENT_DIR/template_dag.py" "$CURRENT_DIR/dags/$DAG_NAME/${DAG_NAME}_dag.py"

echo "DAG $DAG_NAME created successfully in $CURRENT_DIR/dags/$DAG_NAME"

# Activate the DAG by setting 'is_paused' to 'False'
source "$CURRENT_DIR/airflow_venv/bin/activate"

# Set environment variable to silence warnings
export SQLALCHEMY_SILENCE_UBER_WARNING=1

# List the DAGs to ensure the new DAG is registered
"$CURRENT_DIR/airflow_venv/bin/airflow" dags list

# Unpause the DAG
"$CURRENT_DIR/airflow_venv/bin/airflow" dags unpause "$DAG_NAME"
echo "DAG $DAG_NAME activated."
