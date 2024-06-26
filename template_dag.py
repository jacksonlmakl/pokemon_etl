# template_dag.py
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
import yaml
import os

def load_config(dag_folder):
    config_file = os.path.join(dag_folder, f'<PLACEHOLDER_NAME_HERE>_configuration.yaml')
    with open(config_file, 'r') as file:
        return yaml.safe_load(file)

def create_task(dag_folder, task_name):
    def task_function(**kwargs):
        script_path = os.path.join(dag_folder, '<PLACEHOLDER_NAME_HERE>_scripts', task_name)
        exec(open(script_path).read())
    return task_function

dag_folder = os.path.dirname(os.path.abspath(__file__))
config = load_config(dag_folder)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': config['retries'],
    'retry_delay': timedelta(minutes=config['retry_delay']),
}

dag = DAG(
    config['name'],
    default_args=default_args,
    description='A simple tutorial DAG',
    schedule_interval=config['schedule_interval'],
    start_date=datetime(config['start_date_year'], config['start_month_year'], config['start_day_year']),
    catchup=False,
)

previous_task = None

for script in config['python_scripts']:
    task = PythonOperator(
        task_id=script.split('.')[0],
        python_callable=create_task(dag_folder, script),
        dag=dag,
    )
    if previous_task:
        previous_task >> task
    previous_task = task
