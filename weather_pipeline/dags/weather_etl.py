from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'scripts')))

from fetch_weather import main as fetch_weather_main

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 5, 30),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'weather_etl',
    default_args=default_args,
    description='Pipeline batch processing data cuaca setiap 3 jam',
    schedule_interval='0 */3 * * *',  # Setiap 3 jam
    catchup=False,
) as dag:

    fetch_weather_task = PythonOperator(
        task_id='fetch_weather_data',
        python_callable=fetch_weather_main,
    )
