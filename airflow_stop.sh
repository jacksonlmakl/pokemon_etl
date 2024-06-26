#!/bin/bash

# airflow_stop.sh

# Function to stop a process by name
stop_process() {
  PROCESS_NAME=$1
  PID=$(ps aux | grep "$PROCESS_NAME" | grep -v grep | awk '{print $2}')
  if [ -n "$PID" ]; then
    echo "Stopping $PROCESS_NAME with PID $PID..."
    kill -9 $PID
    echo "$PROCESS_NAME stopped."
  else
    echo "$PROCESS_NAME is not running."
  fi
}

# Stop the Airflow scheduler
stop_process "airflow scheduler"

# Stop the Airflow webserver
stop_process "airflow webserver"

echo "Airflow services stopped."
