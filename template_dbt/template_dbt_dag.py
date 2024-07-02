from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import os
import subprocess
import yaml

def load_config(dag_folder):
    config_file = os.path.join(dag_folder, f'<PLACEHOLDER_NAME_HERE>_configuration.yaml')
    with open(config_file, 'r') as file:
        return yaml.safe_load(file)
dag_folder = os.path.dirname(os.path.abspath(__file__))
config = load_config(dag_folder)

def run_dbt_project():
    dbt_project_dir = os.path.join(os.environ["AIRFLOW_HOME"], "dags", "<PLACEHOLDER_NAME_HERE>_dbt_project")
    
    # Path to the airflow_venv activation script
    venv_activate_script = os.path.join(os.environ["AIRFLOW_HOME"], "airflow_venv", "bin", "activate")
    
    # Command to activate the venv and run dbt
    command = f"source {venv_activate_script} && dbt run"
    
    subprocess.run(command, cwd=dbt_project_dir, shell=True, executable='/bin/bash')

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date':datetime(config['start_date_year'], config['start_month_year'], config['start_day_year']),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': config['retries'],
    'retry_delay': timedelta(minutes=config['retry_delay']),
}

dag = DAG(
    '<PLACEHOLDER_NAME_HERE>',
    default_args=default_args,
    description='A simple DBT DAG',
   schedule_interval=config['schedule_interval'],
)

start = DummyOperator(
    task_id='start',
    dag=dag,
)

run_dbt = PythonOperator(
    task_id='run_dbt',
    python_callable=run_dbt_project,
    dag=dag,
)

start >> run_dbt






# from airflow import DAG
# from airflow.operators.dummy_operator import DummyOperator
# from airflow.operators.python_operator import PythonOperator
# from datetime import datetime, timedelta
# import os
# import subprocess

# def run_dbt_project():
#     dbt_project_dir = os.path.join(os.environ["AIRFLOW_HOME"], "dags", "<PLACEHOLDER_NAME_HERE>_dbt_project")
#     subprocess.run(["dbt", "run"], cwd=dbt_project_dir)

# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'start_date': datetime(2023, 1, 1),
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 1,
#     'retry_delay': timedelta(minutes=5),
# }

# dag = DAG(
#     '<PLACEHOLDER_NAME_HERE>',
#     default_args=default_args,
#     description='A simple DBT DAG',
#     schedule_interval=timedelta(days=1),
# )

# start = DummyOperator(
#     task_id='start',
#     dag=dag,
# )

# run_dbt = PythonOperator(
#     task_id='run_dbt',
#     python_callable=run_dbt_project,
#     dag=dag,
# )

# start >> run_dbt
