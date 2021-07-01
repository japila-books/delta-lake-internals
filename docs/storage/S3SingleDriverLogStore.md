# S3SingleDriverLogStore

`S3SingleDriverLogStore` is a [HadoopFileSystemLogStore](HadoopFileSystemLogStore.md).

## Creating Instance

`S3SingleDriverLogStore` takes the following to be created:

* <span id="sparkConf"> `SparkConf` ([Apache Spark]({{ book.spark_core }}/SparkConf))
* <span id="hadoopConf"> Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
