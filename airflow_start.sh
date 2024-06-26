CURRENT_DIR=$(pwd)
source $CURRENT_DIR/airflow_venv/bin/activate
# Restart scheduler
airflow scheduler  &

# Restart webserver
airflow webserver -p 8080  &
