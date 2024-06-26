#!/bin/bash

# airflow_stop.sh

# Function to stop a process by name
stop_process() {
  PROCESS_NAME=$1
  echo "Stopping $PROCESS_NAME..."
  pkill -f "$PROCESS_NAME"
  if [ $? -eq 0 ]; then
    echo "$PROCESS_NAME stopped."
  else
    echo "$PROCESS_NAME not running."
  fi
}

# Function to forcefully kill any process using a specific port
kill_process_on_port() {
  PORT=$1
  echo "Killing process on port $PORT..."
  fuser -k $PORT/tcp
  if [ $? -eq 0 ]; then
    echo "Process on port $PORT killed."
  else
    echo "No process running on port $PORT."
  fi
}

# Stop the Airflow webserver and scheduler
stop_process "airflow webserver"
stop_process "airflow scheduler"

# Kill any process using port 8080 (default webserver port) and 8793 (example port in error message)
kill_process_on_port 8080
kill_process_on_port 8793

# Verify if processes are stopped
if pgrep -f "airflow webserver" > /dev/null; then
  echo "Failed to stop Airflow webserver."
else
  echo "Airflow webserver stopped."
fi

if pgrep -f "airflow scheduler" > /dev/null; then
  echo "Failed to stop Airflow scheduler."
else
  echo "Airflow scheduler stopped."
fi

echo "Airflow services stopped."
