# HadoopFileSystemLogStore

`HadoopFileSystemLogStore` is an extension of the [LogStore](LogStore.md) abstraction for [Hadoop DFS-based log stores](#implementations).

## Implementations

* AzureLogStore
* [HDFSLogStore](HDFSLogStore.md)
* LocalLogStore
* [S3SingleDriverLogStore](S3SingleDriverLogStore.md)

## Creating Instance

`HadoopFileSystemLogStore` takes the following to be created:

* <span id="sparkConf"> `SparkConf` ([Apache Spark]({{ book.spark_core }}/SparkConf))
* <span id="hadoopConf"> Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)

??? note "Abstract Class"
    `HadoopFileSystemLogStore` is an abstract class and cannot be created directly. It is created indirectly for the [concrete HadoopFileSystemLogStores](#implementations).
