import os
from typing import Dict, Any
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

def load_database_config(db_type: str) -> Dict[str, Any]:
    """
    Load database configuration from environment variables.
    
    Args:
        db_type (str): Type of database ('postgres' or 'mysql')
    
    Returns:
        Dict[str, Any]: Database configuration parameters
    """
    load_dotenv()
    
    config = {
        'postgres': {
            'user': os.getenv('POSTGRES_USER'),
            'password': os.getenv('POSTGRES_PASSWORD'),
            'hostname': '127.0.0.1',
            'database': os.getenv('POSTGRES_DB_NEW'),
            'port': os.getenv('POSTGRES_PORT'),
            'dialect': 'postgresql'
        },
        'mysql': {
            'user': os.getenv('MYSQL_USER'),
            'password': os.getenv('MYSQL_PASSWORD'),
            'hostname': '127.0.0.1',
            'database': os.getenv('MYSQL_DATABASE_DW'),
            'port': os.getenv('MYSQL_PORT'),
            'dialect': 'mysql+pymysql'
        }
    }
    
    return config.get(db_type.lower(), {})

def create_database_engine(config: Dict[str, Any]):
    """
    Create SQLAlchemy engine for database connection.
    
    Args:
        config (Dict[str, Any]): Database configuration parameters
    
    Returns:
        sqlalchemy.engine.base.Engine: Database connection engine
    """
    connection_string = (
        f"{config['dialect']}://{config['user']}:{config['password']}"
        f"@{config['hostname']}:{config['port']}/{config['database']}"
    )
    return create_engine(connection_string)

def transfer_data(source_query: str, source_engine, dest_table: str, dest_engine):
    """
    Transfer data from source database to destination database.
    
    Args:
        source_query (str): SQL query to extract data
        source_engine: Source database engine
        dest_table (str): Destination table name
        dest_engine: Destination database engine
    """
    try:
        # Extract data from source database
        df = pd.read_sql(source_query, source_engine)
        
        # Load data into destination database
        df.to_sql(
            name=dest_table, 
            con=dest_engine, 
            if_exists='replace', 
            index=False
        )
        print(f'Data transfer to {dest_table} completed successfully')
    
    except Exception as e:
        print(f'Error during data transfer: {e}')

def main():
    """
    Main function to orchestrate database data transfer.
    """
    # Load database configurations
    source_config = load_database_config('postgres')
    dest_config = load_database_config('mysql')
    
    # Create database engines
    source_engine = create_database_engine(source_config)
    dest_engine = create_database_engine(dest_config)
    
    # Define source query and destination table
    dest_table = 'customer'
    source_query = f"SELECT * FROM public.{dest_table}"
    
    # Perform data transfer
    transfer_data(source_query, source_engine, dest_table, dest_engine)

if __name__ == '__main__':
    main()