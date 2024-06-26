source airflow_venv/bin/activate
# Restart scheduler
airflow scheduler -D

# Restart webserver
airflow webserver -p 8080 -D
