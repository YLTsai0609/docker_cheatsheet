# pull official spark 3.5.1 with python 3
# https://hub.docker.com/_/spark
# NOTE: there are a lot of tags
docker run -it spark:3.5.1-python3 /opt/spark/bin/pyspark

# rdd = spark.sparkContext.parallelize(range(1, 100));print(rdd.sum())