FROM apache/airflow:2.8.2-python3.9
USER root

# Install OpenJDK-17
RUN apt update && \
    apt-get install -y openjdk-17-jdk ant procps && \
    apt-get clean

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64


USER airflow

RUN pip install --no-cache-dir \
    numpy==1.24.3 \
    pandas==1.5.3 \
    lxml \
    pyspark==3.3.2 \
    apache-airflow-providers-apache-spark==5.0.0 \
    requests==2.31 \
    apache-airflow-providers-slack==8.4.0 \
    apache-airflow-providers-openlineage==1.8.0

COPY --chown=airflow:root ./dags /opt/airflow/dags
