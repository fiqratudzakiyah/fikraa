import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

load_dotenv()

# Source PostgreSQL connection parameters
pg_user = os.getenv('POSTGRES_USER')
pg_password = os.getenv('POSTGRES_PASSWORD') 
pg_hostname = '127.0.0.1'
pg_database = os.getenv('POSTGRES_DB_NEW')
pg_port = os.getenv('POSTGRES_PORT')

# Destination MySQL connection parameters
mysql_user = os.getenv('MYSQL_USER')
mysql_password = os.getenv('MYSQL_PASSWORD')
mysql_hostname = '127.0.0.1'
mysql_database = os.getenv('MYSQL_DATABASE_DW')
mysql_port = os.getenv('MYSQL_PORT')

# Create source PostgreSQL engine
pg_engine = create_engine(
    f'postgresql://{pg_user}:{pg_password}@{pg_hostname}:{pg_port}/{pg_database}'
)

# Create destination MySQL engine
mysql_engine = create_engine(
    f'mysql+pymysql://{mysql_user}:{mysql_password}@{mysql_hostname}:{mysql_port}/{mysql_database}'
)

# Extract data from PostgreSQL
query = "SELECT * FROM public.actor"  # Modify this query as needed
df = pd.read_sql(query, pg_engine)

# Load data into MySQL
df.to_sql(
    name='actor', 
    con=mysql_engine, 
    if_exists='replace', 
    index=False
)

print('Data transfer from PostgreSQL to MySQL completed successfully')