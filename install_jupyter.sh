#!/bin/bash

# Define the path to the virtual environment
VENV_DIR="airflow_venv"

# Check if the virtual environment directory exists
if [ ! -d "$VENV_DIR" ]; then
  echo "Virtual environment directory $VENV_DIR does not exist."
  exit 1
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Upgrade pip
pip install --upgrade pip

# Install Jupyter Notebook
pip install jupyter

# Deactivate the virtual environment
deactivate

echo "Jupyter Notebook has been installed in the virtual environment $VENV_DIR"
