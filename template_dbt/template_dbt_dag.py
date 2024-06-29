from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import os
import subprocess

def run_dbt_project():
    dbt_project_dir = os.path.join(os.environ["AIRFLOW_HOME"], "dags", "<PLACEHOLDER_NAME_HERE>_dbt_project")
    subprocess.run(["dbt", "run"], cwd=dbt_project_dir)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    '<PLACEHOLDER_NAME_HERE>',
    default_args=default_args,
    description='A simple DBT DAG',
    schedule_interval=timedelta(days=1),
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
