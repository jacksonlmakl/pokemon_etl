#!/bin/bash

# airflow_development_server_start.sh

# Get the current working directory
CURRENT_DIR=$(pwd)

# Set AIRFLOW_HOME to current directory
export AIRFLOW_HOME="$CURRENT_DIR/airflow_home"

# Activate the virtual environment
source "$AIRFLOW_HOME/airflow_venv/bin/activate"

# Find every requirements.txt file in the dags directory and its subdirectories
find dags -name 'requirements.txt' | while read requirements_file; do
    echo "Installing packages from $requirements_file"
    pip install -r "$requirements_file"
done


# Define the output file
OUTPUT_FILE="master_secrets.yaml"

# Clear the output file if it exists
> $OUTPUT_FILE

# Find all secrets.yaml files in the dags directory and its subdirectories
find dags -type f -name 'secrets.yaml' | while read -r file; do
    # Append the contents of each secrets.yaml to the master file
    echo "Processing $file..."
    cat "$file" >> $OUTPUT_FILE
    echo -e "\n---\n" >> $OUTPUT_FILE  # Optional: Add a separator between files for clarity
done
cp -f secrets.yaml airflow_home/dags/secrets.yaml

# Start the Airflow webserver
echo "Starting Airflow webserver..."
airflow webserver -p 8082 &

# Start the Airflow scheduler
echo "Starting Airflow scheduler..."
airflow scheduler &

echo "Airflow webserver and scheduler started."



# #!/bin/bash

# # airflow_development_server_start.sh

# # Get the current working directory
# CURRENT_DIR=$(pwd)

# # Set AIRFLOW_HOME to current directory
# export AIRFLOW_HOME="$CURRENT_DIR/airflow_home"

# # Activate the virtual environment
# source "$CURRENT_DIR/airflow_venv/bin/activate"

# # Find every requirements.txt file in the dags directory and its subdirectories
# find dags -name 'requirements.txt' | while read requirements_file; do
#     echo "Installing packages from $requirements_file"
#     pip install -r "$requirements_file"
# done

# # Start the Airflow webserver
# echo "Starting Airflow webserver..."
# airflow webserver -p 8082 &

# # Start the Airflow scheduler
# echo "Starting Airflow scheduler..."
# airflow scheduler &

# echo "Airflow webserver and scheduler started."

