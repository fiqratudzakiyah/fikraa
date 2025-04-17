from pyspark.sql import SparkSession
import sys

if __name__ == "__main__":
    spark = SparkSession.builder.appName("SimpleTest").getOrCreate()
    input_file = sys.argv[sys.argv.index("--input-file") + 1]
    df = spark.read.csv(input_file, header=True, inferSchema=True)
    df.show(5)
    spark.stop()