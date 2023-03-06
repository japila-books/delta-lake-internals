# OptimizeExecutor

`OptimizeExecutor` is a [DeltaCommand](../DeltaCommand.md) for [OptimizeTableCommand](OptimizeTableCommand.md) to [optimize a delta table](#optimize).

`OptimizeExecutor` is a [SQLMetricsReporting](../../SQLMetricsReporting.md).

## Creating Instance

`OptimizeExecutor` takes the following to be created:

* <span id="sparkSession"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="deltaLog"> [DeltaLog](../../DeltaLog.md) (of the Delta table to be optimized)
* <span id="partitionPredicate"> Partition predicate expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="zOrderByColumns"> Z-OrderBy Columns (Names)

`OptimizeExecutor` is created when:

* `OptimizeTableCommand` is requested to [run](OptimizeTableCommand.md#run)

## <span id="optimize"> optimize

```scala
optimize(): Seq[Row]
```

`optimize` is used when:

* `OptimizeTableCommand` is requested to [run](OptimizeTableCommand.md#run)

---

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

### <span id="runOptimizeBinJob"> runOptimizeBinJob

```scala
runOptimizeBinJob(
  txn: OptimisticTransaction,
  partition: Map[String, String],
  bin: Seq[AddFile],
  maxFileSize: Long): Seq[FileAction]
```

`runOptimizeBinJob` creates an input `DataFrame` to represent data described by the given [AddFile](../../AddFile.md)s. `runOptimizeBinJob` requests the [deltaLog](../../OptimisticTransaction.md#deltaLog) (of the given [OptimisticTransaction](../../OptimisticTransaction.md)) to [create the DataFrame](../../DeltaLog.md#createDataFrame) with `Optimize` action type.

For [Z-Ordering](index.md#z-ordering) ([isMultiDimClustering](#isMultiDimClustering) flag is enabled), `runOptimizeBinJob` does the following:

1. Calculates the approximate number of files (as the total [size](../../AddFile.md#size) of all the given `AddFile`s divided by the given `maxFileSize`)
1. Repartitions the `DataFrame` to as many partitions as the approximate number of files using [multi-dimensional clustering](MultiDimClustering.md#cluster) for the [z-orderby columns](#zOrderByColumns)

Otherwise, `runOptimizeBinJob` coalesces the `DataFrame` to `1` partition (using `DataFrame.coalesce` operator).

`runOptimizeBinJob` sets a custom description for the job group (for all future Spark jobs started by this thread).

`runOptimizeBinJob` writes out the repartitioned `DataFrame`. `runOptimizeBinJob` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [writeFiles](../../TransactionalWrite.md#writeFiles).

`runOptimizeBinJob` marks all the [AddFile](../../AddFile.md)s (as the result of [writeFiles](../../TransactionalWrite.md#writeFiles)) as [not dataChange](../../AddFile.md#dataChange). No other [FileAction](../../FileAction.md)s are expected or `runOptimizeBinJob` throws an `IllegalStateException`:

```text
Unexpected action [other] with type [class].
File compaction job output should only have AddFiles
```

`runOptimizeBinJob` [creates RemoveFiles for all the given AddFiles](../../AddFile.md#removeWithTimestamp). `runOptimizeBinJob` uses the current timestamp and the `dataChange` flag is disabled (as was earlier with the `AddFile`s).

In the end, `runOptimizeBinJob` returns the [AddFile](../../AddFile.md)s and [RemoveFile](../../RemoveFile.md)s.

### <span id="commitAndRetry"> commitAndRetry

```scala
commitAndRetry(
  txn: OptimisticTransaction,
  optimizeOperation: Operation,
  actions: Seq[Action],
  metrics: Map[String, SQLMetric])(f: OptimisticTransaction => Boolean): Unit
```

`commitAndRetry`...FIXME

## <span id="isMultiDimClustering"> isMultiDimClustering Flag

`OptimizeExecutor` defines `isMultiDimClustering` flag based on whether there are [zOrderByColumns](#zOrderByColumns) specified or not. In other words, `isMultiDimClustering` is `true` for OPTIMIZE ZORDER.

The most important use of `isMultiDimClustering` flag is for [multi-dimensional clustering](MultiDimClustering.md#cluster) while [runOptimizeBinJob](#runOptimizeBinJob).

`OptimizeExecutor` uses it also for the following:

* Determine data (parquet) files to [optimize](#optimize) (that in fact keeps all the files by partition)
* Create a `ZOrderStats` at the end of [optimize](#optimize)
* Keep all the files of a partition in a single bin in [groupFilesIntoBins](#groupFilesIntoBins)
