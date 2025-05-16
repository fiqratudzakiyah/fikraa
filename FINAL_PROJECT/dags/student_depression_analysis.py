from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os

# Atur backend agar tidak error di Docker 
plt.switch_backend('Agg')

# Paths
RAW_PATH = "/opt/airflow/dags/data/student_depression.csv"
CLEANED_PATH = "/opt/airflow/dags/data/cleaned_student_depression.csv"
PLOT_PATH = "/opt/airflow/dags/data/correlation_matrix.png"

# Fungsi extract dan clean data
def extract_data():
    print("Starting data extraction and cleaning...")
    
    df = pd.read_csv('student_depression.csv')
    df.dropna(inplace=True)
    df.to_csv('cleaned_student_depression', index=False)
    print("Data cleaned and saved successfully.")

# Fungsi analisis dan visualisasi
def analyze_data():
    print("Starting data analysis and plotting...")
  
    df = pd.read_csv('cleaned_student_depression')
    correlation_matrix = df.corr(numeric_only=True)

    plt.figure(figsize=(10, 8))
    sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm')
    plt.title("Correlation Matrix")
    plt.tight_layout()
    plt.savefig(PLOT_PATH)
    plt.close()
    print("Plot saved successfully.")

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 5, 14),
}

with DAG(
    dag_id='student_depression_etl',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
    tags=['final_project'],
) as dag:

    t1 = PythonOperator(
        task_id='extract_and_clean',
        python_callable=extract_data,
    )

    t2 = PythonOperator(
        task_id='analyze_and_plot',
        python_callable=analyze_data,
    )

    t1 >> t2
