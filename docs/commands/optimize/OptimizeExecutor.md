# OptimizeExecutor

`OptimizeExecutor` is a [DeltaCommand](../DeltaCommand.md) with a [SQLMetricsReporting](../../SQLMetricsReporting.md).

## Creating Instance

`OptimizeExecutor` takes the following to be created:

* <span id="sparkSession"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="deltaLog"> [DeltaLog](../../DeltaLog.md) (of the Delta table to be optimized)
* <span id="partitionPredicate"> Partition predicate expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="zOrderByColumns"> zOrderByColumns

`OptimizeExecutor` is created when:

* `OptimizeTableCommand` is requested to [run](OptimizeTableCommand.md#run)

## <span id="optimize"> optimize

```scala
optimize(): Seq[Row]
```

`optimize` reads the following configuration properties:

* [spark.databricks.delta.optimize.minFileSize](../../DeltaSQLConf.md#spark.databricks.delta.optimize.minFileSize) for the threshold of the size of files to be grouped together and rewritten as larger ones
* [spark.databricks.delta.optimize.maxFileSize](../../DeltaSQLConf.md#spark.databricks.delta.optimize.maxFileSize) for the maximum desired file size (in bytes) of the compaction output files

`optimize` requests the [DeltaLog](#deltaLog) to [startTransaction](../../DeltaLog.md#startTransaction).

`optimize` requests the `OptimisticTransaction` for the [files](../../OptimisticTransactionImpl.md#filterFiles) matching the [partition predicates](#partitionPredicate).

`optimize` finds the files of the size below the [spark.databricks.delta.optimize.minFileSize](../../DeltaSQLConf.md#spark.databricks.delta.optimize.minFileSize) threshold (that are the files considered for compacting) and groups them by partition values.

`optimize` [group the files into bins](#groupFilesIntoBins) (of the `spark.databricks.delta.optimize.maxFileSize` size).

!!! note
    A bin is a group of files, whose total size does not exceed the desired size. They will be coalesced into a single output file.

`optimize` creates a `ForkJoinPool` with [spark.databricks.delta.optimize.maxThreads](../../DeltaSQLConf.md#spark.databricks.delta.optimize.maxThreads) threads (with the `OptimizeJob` thread prefix). The task pool is then used to parallelize the submission of [runCompactBinJob](#runCompactBinJob) optimization jobs to Spark.

Once the compaction jobs are done, `optimize` tries to commit the transaction (the given actions to the log) when there were any [AddFile](../../AddFile.md)s.

In the end, `optimize` returns a `Row` with the data path (of the Delta table) and the optimize statistics.

`optimize` is used when:

* `OptimizeTableCommand` is requested to [run](OptimizeTableCommand.md#run)
