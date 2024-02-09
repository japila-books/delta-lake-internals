# OptimizeExecutor

`OptimizeExecutor` is a [DeltaCommand](../DeltaCommand.md) for [OptimizeTableCommand](OptimizeTableCommand.md) to [optimize a delta table](#optimize).

`OptimizeExecutor` is a [SQLMetricsReporting](../../SQLMetricsReporting.md).

## Creating Instance

`OptimizeExecutor` takes the following to be created:

* <span id="sparkSession"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="txn"> [OptimisticTransaction](../../OptimisticTransaction.md)
* <span id="partitionPredicate"> Partition predicate expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))
* <span id="zOrderByColumns"> Z-OrderBy Column Names
* <span id="isAutoCompact"> `isAutoCompact` flag
* <span id="optimizeContext"> [DeltaOptimizeContext](DeltaOptimizeContext.md)

`OptimizeExecutor` is created when:

* `OptimizeTableCommand` is [executed](OptimizeTableCommand.md#run)
* `AutoCompactBase` is requested to [compact](../../auto-compaction/AutoCompactBase.md#compact)

## <span id="hilbert"><span id="zorder"> Curve { #curve }

```scala
curve: String
```

`curve` can be one of the two supported values:

* `zorder` for one or more [zOrderByColumns](#zOrderByColumns)
* `hilbert` for no [zOrderByColumns](#zOrderByColumns) and [clustered tables](#isClusteredTable) feature enabled

---

`curve` is used when:

* `OptimizeExecutor` is requested to [runOptimizeBinJob](#runOptimizeBinJob)

## Performing Optimization { #optimize }

```scala
optimize(): Seq[Row]
```

---

`optimize` is used when:

* `OptimizeTableCommand` is [executed](OptimizeTableCommand.md#run)

---

`optimize` reads the following configuration properties:

* [spark.databricks.delta.optimize.minFileSize](../../configuration-properties/DeltaSQLConf.md#spark.databricks.delta.optimize.minFileSize) for the threshold of the size of files to be grouped together and rewritten as larger ones
* [spark.databricks.delta.optimize.maxFileSize](../../configuration-properties/DeltaSQLConf.md#spark.databricks.delta.optimize.maxFileSize) for the maximum desired file size (in bytes) of the compaction output files

`optimize` requests the [DeltaLog](#deltaLog) to [startTransaction](../../DeltaLog.md#startTransaction).

`optimize` requests the `OptimisticTransaction` for the [files](../../OptimisticTransactionImpl.md#filterFiles) matching the [partition predicates](#partitionPredicate).

`optimize` finds the files of the size below the [spark.databricks.delta.optimize.minFileSize](../../configuration-properties/DeltaSQLConf.md#spark.databricks.delta.optimize.minFileSize) threshold (that are the files considered for compacting) and groups them by partition values.

`optimize` [group the files into bins](#groupFilesIntoBins) (of the `spark.databricks.delta.optimize.maxFileSize` size).

!!! note
    A bin is a group of files, whose total size does not exceed the desired size. They will be coalesced into a single output file.

`optimize` creates a `ForkJoinPool` with [spark.databricks.delta.optimize.maxThreads](../../configuration-properties/DeltaSQLConf.md#spark.databricks.delta.optimize.maxThreads) threads (with the `OptimizeJob` thread prefix). The task pool is then used to parallelize the submission of [runCompactBinJob](#runCompactBinJob) optimization jobs to Spark.

Once the compaction jobs are done, `optimize` tries to commit the transaction (the given actions to the log) when there were any [AddFile](../../AddFile.md)s.

In the end, `optimize` returns a `Row` with the data path (of the Delta table) and the optimize statistics.

### groupFilesIntoBins { #groupFilesIntoBins }

```scala
groupFilesIntoBins(
  partitionsToCompact: Seq[(Map[String, String], Seq[AddFile])],
  maxTargetFileSize: Long): Seq[(Map[String, String], Seq[AddFile])]
```

`groupFilesIntoBins`...FIXME

### pruneCandidateFileList { #pruneCandidateFileList }

```scala
pruneCandidateFileList(
  minFileSize: Long,
  maxDeletedRowsRatio: Double,
  files: Seq[AddFile]): Seq[AddFile]
```

`pruneCandidateFileList`...FIXME

### runOptimizeBinJob { #runOptimizeBinJob }

```scala
runOptimizeBinJob(
  txn: OptimisticTransaction,
  partition: Map[String, String],
  bin: Seq[AddFile],
  maxFileSize: Long): Seq[FileAction]
```

!!! note "maxFileSize"
    `maxFileSize` is controlled using [spark.databricks.delta.optimize.maxFileSize](../../configuration-properties/index.md#spark.databricks.delta.optimize.maxFileSize) configuration property.

    Unless it is executed as part of [Auto Compaction](../../auto-compaction/index.md) which uses [spark.databricks.delta.autoCompact.maxFileSize](../../configuration-properties/index.md#autoCompact.maxFileSize) configuration property.

`runOptimizeBinJob` creates an input `DataFrame` for scanning data of the given [AddFile](../../AddFile.md)s. `runOptimizeBinJob` requests the [DeltaLog](../../OptimisticTransaction.md#deltaLog) (of the given [OptimisticTransaction](../../OptimisticTransaction.md)) to [create the DataFrame](../../DeltaLog.md#createDataFrame) (with `Optimize` action type).

`runOptimizeBinJob` creates a so-called `repartitionDF` as follows:

* With [multi-dimensional clustering](#isMultiDimClustering) enabled (i.e., [Z-Order](index.md#z-ordering) or [Liquid Clustering](../../liquid-clustering/index.md)), `runOptimizeBinJob` does the following:

    1. Calculates the approximate number of files (as the total [size](../../AddFile.md#size) of all the given [AddFile](../../AddFile.md)s divided by the given `maxFileSize`)
    1. Repartitions the `DataFrame` to as many partitions as the approximate number of files using [multi-dimensional clustering](MultiDimClustering.md#cluster) (with the `DataFrame` to scan, the approximate number of files, the [clusteringColumns](#clusteringColumns) and the [curve](#curve))

* Otherwise, `runOptimizeBinJob` repartitions the `DataFrame` to a one single partition using the following `DataFrame` operators based on [spark.databricks.delta.optimize.repartition.enabled](../../configuration-properties/index.md#spark.databricks.delta.optimize.repartition.enabled) configuration property:

    * `DataFrame.repartition` with [spark.databricks.delta.optimize.repartition.enabled](../../configuration-properties/index.md#spark.databricks.delta.optimize.repartition.enabled) enabled
    * `DataFrame.coalesce`, otherwise

`runOptimizeBinJob` sets a custom description for the job group (for all future Spark jobs started by this thread).

`runOptimizeBinJob` writes out the repartitioned `DataFrame`. `runOptimizeBinJob` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [write data out](../../TransactionalWrite.md#writeFiles).

`runOptimizeBinJob` marks all the [AddFile](../../AddFile.md)s (the result of [writting data out](../../TransactionalWrite.md#writeFiles)) as [not dataChange](../../AddFile.md#dataChange).

??? note "IllegalStateException for non-`AddFile`s"
    No other [FileAction](../../FileAction.md)s are expected or `runOptimizeBinJob` throws an `IllegalStateException`:

    ```text
    Unexpected action [other] with type [class].
    File compaction job output should only have AddFiles
    ```

`runOptimizeBinJob` [creates RemoveFiles for all the given AddFiles](../../AddFile.md#removeWithTimestamp). `runOptimizeBinJob` uses the current timestamp and the `dataChange` flag is disabled (as was earlier with the `AddFile`s).

In the end, `runOptimizeBinJob` returns the [AddFile](../../AddFile.md)s and [RemoveFile](../../RemoveFile.md)s.

### commitAndRetry { #commitAndRetry }

```scala
commitAndRetry(
  txn: OptimisticTransaction,
  optimizeOperation: Operation,
  actions: Seq[Action],
  metrics: Map[String, SQLMetric])(f: OptimisticTransaction => Boolean): Unit
```

`commitAndRetry`...FIXME

### createMetrics { #createMetrics }

```scala
createMetrics(
  sparkContext: SparkContext,
  addedFiles: Seq[AddFile],
  removedFiles: Seq[RemoveFile],
  removedDVs: Seq[DeletionVectorDescriptor]): Map[String, SQLMetric]
```

`createMetrics`...FIXME

## isMultiDimClustering Flag { #isMultiDimClustering }

`OptimizeExecutor` defines `isMultiDimClustering` flag that is enabled (`true`) when either holds:

* [Clustered Tables](#isClusteredTable) are supported
* [ZORDER BY Columns](#zOrderByColumns) are specified

The most important use of `isMultiDimClustering` flag is for [multi-dimensional clustering](MultiDimClustering.md#cluster) while [runOptimizeBinJob](#runOptimizeBinJob).

`OptimizeExecutor` uses it also for the following:

* Determine data (parquet) files to [optimize](#optimize) (that in fact keeps all the files by partition)
* Create a `ZOrderStats` at the end of [optimize](#optimize)
* Keep all the files of a partition in a single bin in [groupFilesIntoBins](#groupFilesIntoBins)

## isClusteredTable Flag { #isClusteredTable }

`OptimizeExecutor` defines `isClusteredTable` flag that is enabled (`true`) when [clustered tables are supported](../../liquid-clustering/ClusteredTableUtilsBase.md#isSupported) (based on the [Protocol](../../Snapshot.md#protocol) of the [table snapshot](../../OptimisticTransaction.md#snapshot) under the [OptimisticTransaction](#txn)).

`isClusteredTable` is used in the following:

* [clusteringColumns](#clusteringColumns)
* [curve](#curve)
* [isMultiDimClustering](#isMultiDimClustering)
* [runOptimizeBinJob](#runOptimizeBinJob)
