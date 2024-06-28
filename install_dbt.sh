#!/bin/bash
source airflow_venv/bin/activate
# Check if DBT is already installed
if ! command -v dbt &> /dev/null
then
    echo "DBT not found, installing DBT..."
    
    # Update package list and install dependencies
    sudo apt-get update
    sudo apt-get install -y python3-pip
    
    # Install DBT
    pip3 install dbt

    # Verify DBT installation
    if command -v dbt &> /dev/null
    then
        echo "DBT installed successfully."
    else
        echo "DBT installation failed."
        exit 1
    fi
else
    echo "DBT is already installed."
fi

# Install DBT adapter for Snowflake (or any other specific adapter you need)
pip3 install dbt-snowflake

# Verify the installation of DBT Snowflake adapter
if dbt --version | grep -q "dbt-snowflake"
then
    echo "DBT Snowflake adapter installed successfully."
else
    echo "DBT Snowflake adapter installation failed."
    exit 1
fi

echo "All necessary components are installed."
