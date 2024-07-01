#!/bin/bash

# install_airflow.sh
AIRFLOW_VERSION=2.5.1
PYTHON_VERSION=3.8
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

# Install python3.8-venv if it's not installed
if ! dpkg -s python3.8-venv > /dev/null 2>&1; then
  echo "Installing python3.8-venv package..."
  sudo apt-get update
  sudo apt-get install -y python3.8-venv
fi

# Get the current working directory
CURRENT_DIR=$(pwd)

# Set AIRFLOW_HOME to current directory
export AIRFLOW_HOME="$CURRENT_DIR/airflow_home"

# Create a virtual environment in the current directory
python3 -m venv "$AIRFLOW_HOME/airflow_venv"

# Activate the virtual environment
source "$AIRFLOW_HOME/airflow_venv/bin/activate"

# Upgrade pip
pip install --upgrade pip

# Create the Airflow home directory
mkdir -p "$AIRFLOW_HOME"

# Install Apache Airflow
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Initialize the Airflow database
airflow db init

# Create an admin user with username 'admin' and password 'admin'
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin

# Create the dags folder in the AIRFLOW_HOME directory
mkdir -p "$AIRFLOW_HOME/dags"

# Update airflow.cfg to set the dags folder and other paths
sed -i "s|dags_folder = .*|dags_folder = $AIRFLOW_HOME/dags|" "$AIRFLOW_HOME/airflow.cfg"
sed -i "s|base_log_folder = .*|base_log_folder = $AIRFLOW_HOME/logs|" "$AIRFLOW_HOME/airflow.cfg"
sed -i "s|sql_alchemy_conn = .*|sql_alchemy_conn = sqlite:///$AIRFLOW_HOME/airflow.db|" "$AIRFLOW_HOME/airflow.cfg"

echo "Airflow installation completed. Admin user created with username 'admin' and password 'admin'."
echo "Airflow home directory is set to $AIRFLOW_HOME"
echo "Remember to activate your virtual environment with 'source $AIRFLOW_HOME/airflow_venv/bin/activate' before using Airflow."


# #!/bin/bash

# # install_airflow.sh
# AIRFLOW_VERSION=2.5.1
# PYTHON_VERSION=3.8
# CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

# # Install python3.8-venv if it's not installed
# if ! dpkg -s python3.8-venv > /dev/null 2>&1; then
#   echo "Installing python3.8-venv package..."
#   sudo apt-get update
#   sudo apt-get install -y python3.8-venv
# fi

# # Get the current working directory
# CURRENT_DIR=$(pwd)

# # Set AIRFLOW_HOME to current directory
# export AIRFLOW_HOME="$CURRENT_DIR/airflow_home"

# # Create a virtual environment in the current directory
# python3 -m venv "$CURRENT_DIR/airflow_venv"

# # Activate the virtual environment
# source "$CURRENT_DIR/airflow_venv/bin/activate"

# # Upgrade pip
# pip install --upgrade pip

# # Create the Airflow home directory
# mkdir -p "$AIRFLOW_HOME"

# # Install Apache Airflow
# pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# # Initialize the Airflow database
# airflow db init

# # Create an admin user with username 'admin' and password 'admin'
# airflow users create \
#     --username admin \
#     --firstname Admin \
#     --lastname User \
#     --role Admin \
#     --email admin@example.com \
#     --password admin

# # Create the dags folder in the AIRFLOW_HOME directory
# mkdir -p "$AIRFLOW_HOME/dags"

# # Update airflow.cfg to set the dags folder and other paths
# sed -i "s|dags_folder = .*|dags_folder = $AIRFLOW_HOME/dags|" "$AIRFLOW_HOME/airflow.cfg"
# sed -i "s|base_log_folder = .*|base_log_folder = $AIRFLOW_HOME/logs|" "$AIRFLOW_HOME/airflow.cfg"
# sed -i "s|sql_alchemy_conn = .*|sql_alchemy_conn = sqlite:///$AIRFLOW_HOME/airflow.db|" "$AIRFLOW_HOME/airflow.cfg"

# echo "Airflow installation completed. Admin user created with username 'admin' and password 'admin'."
# echo "Airflow home directory is set to $AIRFLOW_HOME"
# echo "Remember to activate your virtual environment with 'source $CURRENT_DIR/airflow_venv/bin/activate' before using Airflow."
