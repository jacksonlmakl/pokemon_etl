#!/bin/bash

# Activate the virtual environment if necessary
source airflow_venv/bin/activate

# Generate a Jupyter configuration file if it doesn't exist
jupyter notebook --generate-config -y

# Update the Jupyter configuration to disable token authentication
echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py

# Launch Jupyter Notebook in the specified directory and port
jupyter notebook --notebook-dir=dags --port=8888 --ip=0.0.0.0 --allow-root --no-browser &
