FROM apache/airflow:2.4.3-python3.9

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    && apt-get clean

USER airflow

# Install Python packages with pinned versions
RUN pip install --no-cache-dir \
    numpy==1.24.3 \
    pandas==1.5.3 \
    seaborn \
    matplotlib \
    scikit-learn \
    psycopg2-binary \
    sqlalchemy
