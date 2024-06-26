#!/bin/bash

# Create log directories and placeholder log files
mkdir -p /opt/airflow/logs/scheduler
mkdir -p /opt/airflow/logs/webserver
touch /opt/airflow/logs/scheduler/scheduler.log
touch /opt/airflow/logs/webserver/webserver.log

# Activate the virtual environment
source /opt/airflow/airflow_venv/bin/activate

# Initialize the Airflow database
airflow db init

airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin
    
# Start the Airflow webserver and scheduler
echo "Starting Airflow webserver..."
airflow webserver --log-file /opt/airflow/logs/webserver/webserver.log &

echo "Starting Airflow scheduler..."
airflow scheduler --log-file /opt/airflow/logs/scheduler/scheduler.log &


# Keep the container running by tailing the log files
tail -f /opt/airflow/logs/scheduler/scheduler.log /opt/airflow/logs/webserver/webserver.log
