# SparkBatch

`SparkBatch` is a `Batch` ([Spark SQL]({{ book.spark_sql }}/connector/Batch/)).

## Creating Instance

`SparkBatch` takes the following to be created:

* <span id="snapshot"> `Snapshot`
* <span id="dataSchema"> Data Schema
* <span id="partitionSchema"> Partition Schema
* <span id="readDataSchema"> Data Schema for Read
* <span id="partitionedFiles"> `PartitionedFile`s
* <span id="pushedToKernelFilters"> `Predicate`s
* <span id="dataFilters"> Data `Filter`s
* <span id="totalBytes"> Total Bytes
* <span id="scalaOptions"> Read Options
* <span id="hadoopConf"> Hadoop `Configuration`

`SparkBatch` is created when:

* `SparkScan` is requested to [toBatch](SparkScan.md#toBatch)
