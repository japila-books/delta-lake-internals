# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](DeltaCommand.md) that represents a [DeltaMergeInto](DeltaMergeInto.md) logical command at execution time.

`MergeIntoCommand` is a logical command (Spark SQL's [RunnableCommand](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/RunnableCommand/)).

!!! tip
    Learn more on the internals of `MergeIntoCommand` in [Demo: Merge Operation](../demo/merge-operation.md).

## Performance Metrics

Name     | web UI
---------|----------
`numSourceRows` | number of source rows
[numTargetRowsCopied](#numTargetRowsCopied) | number of target rows rewritten unmodified
`numTargetRowsInserted` | number of inserted rows
`numTargetRowsUpdated` | number of updated rows
`numTargetRowsDeleted` | number of deleted rows
`numTargetFilesBeforeSkipping` | number of target files before skipping
`numTargetFilesAfterSkipping` | number of target files after skipping
`numTargetFilesRemoved` | number of files removed to target
`numTargetFilesAdded` | number of files added to target

### <span id="numTargetRowsCopied"> number of target rows rewritten unmodified

`numTargetRowsCopied` performance metric (like the other [metrics](#performance-metrics)) is turned into a non-deterministic user-defined function (UDF).

`numTargetRowsCopied` becomes `incrNoopCountExpr` UDF.

`incrNoopCountExpr` UDF is resolved on a joined plan and used to create a [JoinedRowProcessor](JoinedRowProcessor.md#noopCopyOutput) for [processing partitions](#processPartition) of the joined plan `Dataset`.

## Creating Instance

`MergeIntoCommand` takes the following to be created:

* [Source Data](#source)
* <span id="target"> Target Data (`LogicalPlan`)
* <span id="targetFileIndex"> [TahoeFileIndex](../TahoeFileIndex.md)
* <span id="condition"> Condition Expression
* <span id="matchedClauses"> Matched Clauses (`Seq[DeltaMergeIntoMatchedClause]`)
* <span id="notMatchedClause"> Optional Non-Matched Clause (`Option[DeltaMergeIntoInsertClause]`)
* <span id="migratedSchema"> Migrated Schema

`MergeIntoCommand` is created when [PreprocessTableMerge](../PreprocessTableMerge.md) logical resolution rule is executed (on a [DeltaMergeInto](DeltaMergeInto.md) logical command).

## <span id="source"> Source Data (to Merge From)

When [created](#creating-instance), `MergeIntoCommand` is given a `LogicalPlan` for the source data to merge from (referred to internally as _source_).

The source `LogicalPlan` is used twice:

* Firstly, in one of the following:
    * An inner join (in [findTouchedFiles](#findTouchedFiles)) that is `count` in web UI
    * A leftanti join (in [writeInsertsOnlyWhenNoMatchedClauses](#writeInsertsOnlyWhenNoMatchedClauses))
* Secondly, in rightOuter or fullOuter join (in [writeAllChanges](#writeAllChanges))

!!! tip
    Enable `DEBUG` logging level for [org.apache.spark.sql.delta.commands.MergeIntoCommand](#logging) logger to see the inner-workings of [writeAllChanges](#writeAllChanges).

## <span id="run"> Executing Command

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run` requests the [target DeltaLog](#targetDeltaLog) to [start a new transaction](../DeltaLog.md#withNewTransaction).

With [spark.databricks.delta.schema.autoMerge.enabled](../DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property enabled, `run` [updates the metadata](../ImplicitMetadataOperation.md#updateMetadata) (of the transaction).

<span id="run-deltaActions">
`run` determines Delta actions ([RemoveFile](../RemoveFile.md)s and [AddFile](../AddFile.md)s).

??? todo "Describe `deltaActions` part"

With [spark.databricks.delta.history.metricsEnabled](../DeltaSQLConf.md#DELTA_HISTORY_METRICS_ENABLED) configuration property enabled, `run` requests the [current transaction](../OptimisticTransaction.md) to [register SQL metrics for the Delta operation](../SQLMetricsReporting.md#registerSQLMetrics).

`run` requests the [current transaction](../OptimisticTransaction.md) to [commit](../OptimisticTransactionImpl.md#commit) (with the [Delta actions](#run-deltaActions) and `Merge` operation).

`run` records the Delta event.

`run` posts a `SparkListenerDriverAccumUpdates` Spark event (with the metrics).

In the end, `run` requests the `CacheManager` to `recacheByPlan`.

`run` is part of the `RunnableCommand` ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/RunnableCommand/)) abstraction.

### <span id="run-exceptions"> Exceptions

`run` throws an `AnalysisException` when the target schema is different than the delta table's (has changed after analysis phase):

```text
The schema of your Delta table has changed in an incompatible way since your DataFrame or DeltaTable object was created. Please redefine your DataFrame or DeltaTable object. Changes:
[schemaDiff]
This check can be turned off by setting the session configuration key spark.databricks.delta.checkLatestSchemaOnRead to false.
```

### <span id="writeAllChanges"> writeAllChanges

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile]): Seq[AddFile]
```

`writeAllChanges` builds the target output columns (possibly with some `null`s for the target columns that are not in the current schema).

<span id="writeAllChanges-newTarget">
`writeAllChanges` [builds a target logical query plan for the AddFiles](#buildTargetPlanWithFiles).

<span id="writeAllChanges-joinType">
`writeAllChanges` determines a join type to use (`rightOuter` or `fullOuter`).

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges using [joinType] join:
source.output: [outputSet]
target.output: [outputSet]
condition: [condition]
newTarget.output: [outputSet]
```

<span id="writeAllChanges-joinedDF">
`writeAllChanges` creates a `joinedDF` DataFrame that is a join of the DataFrames for the [source](#source) and the new [target](#writeAllChanges-newTarget) logical plans with the given [join condition](#condition) and the [join type](#writeAllChanges-joinType).

`writeAllChanges` creates a `JoinedRowProcessor` that is then used to map over partitions of the [joined DataFrame](#writeAllChanges-joinedDF).

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges: join output plan:
[outputDF.queryExecution]
```

`writeAllChanges` requests the input [OptimisticTransaction](../OptimisticTransaction.md) to [writeFiles](../TransactionalWrite.md#writeFiles) (possibly repartitioning by the partition columns if table is partitioned and [spark.databricks.delta.merge.repartitionBeforeWrite.enabled](../DeltaSQLConf.md#MERGE_REPARTITION_BEFORE_WRITE) configuration property is enabled).

`writeAllChanges` is used when `MergeIntoCommand` is requested to [run](#run).

### <span id="findTouchedFiles"> findTouchedFiles

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): Seq[AddFile]
```

!!! important
    `findTouchedFiles` is such a fine piece of art (_a gem_). It uses a custom accumulator, a UDF (to use this accumulator to record touched file names) and `input_file_name()` standard function for the names of the files read.

    It is always worth keeping in mind that Delta Lake uses files for data storage and that is why `input_file_name()` standard function works. It would not work for non-file-based data sources.

??? note "Example: Understanding the Internals of `findTouchedFiles`"
    
    The following query writes out a 10-element dataset using the default parquet data source to `/tmp/parquet` directory:

    ```scala
    val target = "/tmp/parquet"
    spark.range(10).write.save(target)
    ```

    The number of parquet part files varies based on the number of partitions (CPU cores).

    The following query loads the parquet dataset back alongside `input_file_name()` standard function to mimic `findTouchedFiles`'s behaviour.

    ```scala
    val FILE_NAME_COL = "_file_name_"
    val dataFiles = spark.read.parquet(target).withColumn(FILE_NAME_COL, input_file_name())
    ```

    ```text
    scala> dataFiles.show(truncate = false)
    +---+---------------------------------------------------------------------------------------+
    |id |_file_name_                                                                            |
    +---+---------------------------------------------------------------------------------------+
    |4  |file:///tmp/parquet/part-00007-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |0  |file:///tmp/parquet/part-00001-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |3  |file:///tmp/parquet/part-00006-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |6  |file:///tmp/parquet/part-00011-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |1  |file:///tmp/parquet/part-00003-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |8  |file:///tmp/parquet/part-00014-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |2  |file:///tmp/parquet/part-00004-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |7  |file:///tmp/parquet/part-00012-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |5  |file:///tmp/parquet/part-00009-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    |9  |file:///tmp/parquet/part-00015-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    +---+---------------------------------------------------------------------------------------+
    ```

    As you may have thought, not all part files have got data and so they are not included in the dataset. That is when `findTouchedFiles` uses `groupBy` operator and `count` action to calculate match frequency.

    ```text
    val counts = dataFiles.groupBy(FILE_NAME_COL).count()
    scala> counts.show(truncate = false)
    +---------------------------------------------------------------------------------------+-----+
    |_file_name_                                                                            |count|
    +---------------------------------------------------------------------------------------+-----+
    |file:///tmp/parquet/part-00015-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00007-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00003-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00011-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00012-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00006-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00001-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00004-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00009-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    |file:///tmp/parquet/part-00014-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1    |
    +---------------------------------------------------------------------------------------+-----+
    ```

    Let's load all the part files in the `/tmp/parquet` directory and find which file(s) have no data.

    ```scala
    import scala.sys.process._
    val cmd = (s"ls $target" #| "grep .parquet").lineStream
    val allFiles = cmd.toArray.toSeq.toDF(FILE_NAME_COL)
      .select(concat(lit(s"file://$target/"), col(FILE_NAME_COL)) as FILE_NAME_COL)
    val joinType = "left_anti" // MergeIntoCommand uses inner as it wants data file
    val noDataFiles = allFiles.join(dataFiles, Seq(FILE_NAME_COL), joinType)
    ```

    Mind that the data vs non-data datasets could be different, but that should not "interfere" with the main reasoning flow.

    ```text
    scala> noDataFiles.show(truncate = false)
    +---------------------------------------------------------------------------------------+
    |_file_name_                                                                            |
    +---------------------------------------------------------------------------------------+
    |file:///tmp/parquet/part-00000-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|
    +---------------------------------------------------------------------------------------+
    ```

`findTouchedFiles` registers an accumulator to collect all the distinct files that need to be rewritten (_touched files_).

!!! note
    The name of the accumulator is **internal.metrics.MergeIntoDelta.touchedFiles** and `internal.metrics` part is supposed to hide it from web UI as potentially large (set of file names to be rewritten).

<span id="findTouchedFiles-recordTouchedFileName">
`findTouchedFiles` defines a nondeterministic UDF that adds the file names to the accumulator (_recordTouchedFileName_).

`findTouchedFiles` splits conjunctive predicates (`And` binary expressions) in the [condition](#condition) expression and collects the predicates that use the [target](#target)'s columns (_targetOnlyPredicates_). `findTouchedFiles` requests the given [OptimisticTransaction](../OptimisticTransaction.md) for the [files that match the target-only predicates](../OptimisticTransactionImpl.md#filterFiles).

!!! note
    This step looks similar to **filter predicate pushdown**.

`findTouchedFiles` creates one `DataFrame` for the [source data](#source) (using `Dataset.ofRows` utility).

!!! tip
    Learn more about [Dataset.ofRows]({{ book.spark_sql }}/Dataset/#ofRows) utility in [The Internals of Spark SQL]({{ book.spark_sql }}) online book.

`findTouchedFiles` [builds a logical query plan](#buildTargetPlanWithFiles) for the files (matching the predicates) and creates another `DataFrame` for the target data. `findTouchedFiles` adds two columns to the target dataframe:

1. `_row_id_` for `monotonically_increasing_id()` standard function
1. `_file_name_` for `input_file_name()` standard function

`findTouchedFiles` creates (a `DataFrame` that is) an INNER JOIN of the source and target `DataFrame`s using the [condition](#condition) expression.

`findTouchedFiles` takes the joined dataframe and selects `_row_id_` column and the [recordTouchedFileName](#findTouchedFiles-recordTouchedFileName) UDF on the `_file_name_` column as `one`. The `DataFrame` is internally known as `collectTouchedFiles`.

`findTouchedFiles` uses `groupBy` operator on `_row_id_` to calculate a sum of all the values in the `one` column (as `count` column) in the two-column `collectTouchedFiles` dataset. The `DataFrame` is internally known as `matchedRowCounts`.

!!! note
    No Spark job has been submitted yet. `findTouchedFiles` is still in "query preparation" mode.

`findTouchedFiles` uses `filter` on the `count` column (in the `matchedRowCounts` dataset) with values greater than `1`. If there are any, `findTouchedFiles` throws an `UnsupportedOperationException` exception:

```text
Cannot perform MERGE as multiple source rows matched and attempted to update the same
target row in the Delta table. By SQL semantics of merge, when multiple source rows match
on the same target row, the update operation is ambiguous as it is unclear which source
should be used to update the matching target row.
You can preprocess the source table to eliminate the possibility of multiple matches.
```

!!! note
    Since `findTouchedFiles` uses `count` action there should be a Spark SQL query reported (and possibly Spark jobs) in web UI.

`findTouchedFiles` requests the `touchedFilesAccum` accumulator for the touched file names.

`findTouchedFiles` prints out the following TRACE message to the logs:

```text
findTouchedFiles: matched files:
  [touchedFileNames]
```

`findTouchedFiles`...FIXME

### <span id="buildTargetPlanWithFiles"> Building Target Logical Query Plan for AddFiles

```scala
buildTargetPlanWithFiles(
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile]): LogicalPlan
```

`buildTargetPlanWithFiles` creates a DataFrame to represent the given [AddFile](../AddFile.md)s to access the analyzed logical query plan. `buildTargetPlanWithFiles` requests the given [OptimisticTransaction](../OptimisticTransaction.md) for the [DeltaLog](../OptimisticTransaction.md#deltaLog) to [create a DataFrame](../DeltaLog.md#createDataFrame) (for the [Snapshot](../OptimisticTransaction.md#snapshot) and the given [AddFile](../AddFile.md)s).

In the end, `buildTargetPlanWithFiles` creates a `Project` logical operator with `Alias` expressions so the output columns of the analyzed logical query plan (of the `DataFrame` of the `AddFiles`) reference the target's output columns (by name).

!!! note
    The output columns of the target delta table are associated with a [OptimisticTransaction](../OptimisticTransaction.md) as the [Metadata](../OptimisticTransactionImpl.md#metadata).

    ```scala
    deltaTxn.metadata.schema
    ```

### <span id="writeInsertsOnlyWhenNoMatchedClauses"> writeInsertsOnlyWhenNoMatchedClauses

```scala
writeInsertsOnlyWhenNoMatchedClauses(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): Seq[AddFile]
```

`writeInsertsOnlyWhenNoMatchedClauses`...FIXME

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.MergeIntoCommand` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.commands.MergeIntoCommand=ALL
```

Refer to [Logging](../spark-logging.md).
