from datetime import timedelta
from airflow import DAG
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from airflow.utils.dates import days_ago

default_args = {
    "owner": "data_analyst",
    "retry_delay": timedelta(minutes=3),
}

amazon_spark_etl_dag = DAG(
    dag_id="amazon_sales_spark_etl",
    default_args=default_args,
    schedule_interval=None,
    dagrun_timeout=timedelta(minutes=45),
    description="Run Spark ETL for Amazon Sales Data",
    start_date=days_ago(2),
    tags=['amazon', 'sales', 'spark', 'etl'],
)

process_amazon_sales = SparkSubmitOperator(
    task_id="process_amazon_sales_data",
    application="/spark-scripts/amazon_sales_etl.py",
    conn_id="spark_main",  
    application_args=[
        "--input-file", "/opt/airflow/data/Amazon_Sale_Report.csv",
        "--output-table", "amazon_sales_summary"
    ],
    conf={
        "spark.driver.memory": "1g",
        "spark.executor.cores": "2",
        "spark.executor.memory": "2g"
    },
    dag=amazon_spark_etl_dag,
)