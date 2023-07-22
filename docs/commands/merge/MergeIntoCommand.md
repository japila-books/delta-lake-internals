# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](../DeltaCommand.md) (indirectly as a [MergeIntoCommandBase](MergeIntoCommandBase.md)) that represents a [DeltaMergeInto](DeltaMergeInto.md) logical command at execution.

`MergeIntoCommand` is transactional (and starts a new transaction when [executed](#runMerge)).

`MergeIntoCommand` can [optimize output generation](MergeOutputGeneration.md) ([ClassicMergeExecutor](ClassicMergeExecutor.md) or [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md)) when xxx.

## Creating Instance

`MergeIntoCommand` takes the following to be created:

* [Source Data](#source)
* <span id="target"> Target table ([LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="targetFileIndex"> [TahoeFileIndex](../../TahoeFileIndex.md)
* <span id="condition"> Merge Condition ([Expression]({{ book.spark_sql }}/expressions/Expression/))
* <span id="matchedClauses"> [WHEN MATCHED Clause](DeltaMergeIntoMatchedClause.md)s
* <span id="notMatchedClauses"> [Non-Matched Insert Clause](DeltaMergeIntoInsertClause.md)s
* <span id="notMatchedBySourceClauses"> [WHEN NOT MATCHED BY SOURCE Clause](DeltaMergeIntoNotMatchedBySourceClause.md)s
* [Migrated Schema](#migratedSchema)

`MergeIntoCommand` is created when:

* [PreprocessTableMerge](../../PreprocessTableMerge.md) logical resolution rule is executed (to resolve a [DeltaMergeInto](DeltaMergeInto.md) logical command)

### Source Data { #source }

```scala
source: LogicalPlan
```

When [created](#creating-instance), `MergeIntoCommand` is given a `LogicalPlan` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalPlan)) of the source data to merge from (internally referred to as _source_).

The `source` is used twice:

* Firstly, in one of the following:
    * An inner join (in [findTouchedFiles](#findTouchedFiles)) that is `count` in web UI
    * A leftanti join (in [writeInsertsOnlyWhenNoMatchedClauses](#writeInsertsOnlyWhenNoMatchedClauses))
* Secondly, in right or full outer join (in [writeAllChanges](#writeAllChanges))

!!! tip
    Enable `DEBUG` logging level for [org.apache.spark.sql.delta.commands.MergeIntoCommand](#logging) logger to see the inner-workings of [writeAllChanges](#writeAllChanges).

### Migrated Schema { #migratedSchema }

```scala
migratedSchema: Option[StructType]
```

`MergeIntoCommand` can be given a `migratedSchema` ([Spark SQL]({{ book.spark_sql }}/types/StructType)).

## Running Merge { #runMerge }

??? note "MergeIntoCommandBase"

    ```scala
    runMerge(
      spark: SparkSession): Seq[Row]
    ```

    `runMerge` is part of the [MergeIntoCommandBase](MergeIntoCommandBase.md#runMerge) abstraction.

`runMerge` records the start time.

`runMerge` [starts a new transaction](../../DeltaLog.md#withNewTransaction) (on the [targetDeltaLog](MergeIntoCommandBase.md#targetDeltaLog)).

If [hasBeenExecuted](#hasBeenExecuted), `runMerge` [announces the updates](../DeltaCommand.md#sendDriverMetrics) of the [metrics](MergeIntoCommandBase.md#metrics) and quits early (returns no `Row`s).

!!! warning "FIXME When would `hasBeenExecuted` happen?"

??? note "DeltaAnalysisException"
    In case the schema of the [target](#target) table changed (compared to the time the [transaction started](MergeIntoCommandBase.md#targetDeltaLog)), `runMerge` throws a `DeltaAnalysisException`.

    ---

    The [schema](../../Metadata.md#schema) of a delta table is in the [Metadata](../../Metadata.md#schema) of the [OptimisticTransactionImpl](../../OptimisticTransactionImpl.md).

When [canMergeSchema](MergeIntoCommandBase.md#canMergeSchema), `runMerge` [updateMetadata](../../ImplicitMetadataOperation.md#updateMetadata).

`runMerge` [prepareSourceDFAndReturnMaterializeReason](#prepareSourceDFAndReturnMaterializeReason).

At this stage, `runMerge` is finally ready to apply all the necessary changes to the delta table ( _execute this merge_) that result in a collection of [FileAction](../../FileAction.md)s (`deltaActions`).
`runMerge` writes out [inserts only](InsertOnlyMergeExecutor.md#writeOnlyInserts) or [more](ClassicMergeExecutor.md#writeAllChanges) based on the following:

* For [insert-only merges](MergeIntoCommandBase.md#isInsertOnly) with [merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/index.md#MERGE_INSERT_ONLY_ENABLED) enabled
* Whether there are any [files to rewrite](ClassicMergeExecutor.md#findTouchedFiles)

!!! note "`runMerge` and `MergeOutputGeneration`s"
    `runMerge` uses [InsertOnlyMergeExecutor](InsertOnlyMergeExecutor.md) or [ClassicMergeExecutor](ClassicMergeExecutor.md) output generators.

`runMerge` [collects the merge statistics](MergeIntoCommandBase.md#collectMergeStats).

`runMerge` requests the `CacheManager` ([Spark SQL]({{ book.spark_sql }}/CacheManager)) to re-cache all the cached logical plans that refer to the [target](#target) logical plan (since it has just changed).

`runMerge` [announces the updates](../DeltaCommand.md#sendDriverMetrics) of the [metrics](MergeIntoCommandBase.md#metrics).

In the end, `runMerge` returns the following performance metrics (as a single `Row`):

Column Name | Metric
------------|-------
 `num_affected_rows` | Total of the values of the metrics: <ul><li>[number of updated rows](MergeIntoCommandBase.md#numTargetRowsUpdated)<li>[number of deleted rows](MergeIntoCommandBase.md#numTargetRowsDeleted)<li>[number of inserted rows](MergeIntoCommandBase.md#numTargetRowsInserted)</ul>
 `num_updated_rows` | [number of updated rows](MergeIntoCommandBase.md#numTargetRowsUpdated)
 `num_deleted_rows` | [number of deleted rows](MergeIntoCommandBase.md#numTargetRowsDeleted)
 `num_inserted_rows` | [number of inserted rows](MergeIntoCommandBase.md#numTargetRowsInserted)

## Target Delta Table { #targetDeltaLog }

```scala
targetDeltaLog: DeltaLog
```

`targetDeltaLog` is the [DeltaLog](../../TahoeFileIndex.md#deltaLog) (of the [TahoeFileIndex](#targetFileIndex)) of the target delta table.

`targetDeltaLog` is used for the following:

* [Start a new transaction](../../DeltaLog.md#withNewTransaction) when [executed](#run)
* To access the [Data Path](../../DeltaLog.md#dataPath) when [finding files to rewrite](#findTouchedFiles)

??? note "Lazy Value"
    `targetDeltaLog` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and cached afterwards.

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      spark: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) abstraction.

`run` is a transactional operation that is made up of the following steps:

1. [Begin Transaction](#run-withNewTransaction)
    1. [schema.autoMerge.enabled](#run-canMergeSchema)
    1. [FileActions](#run-deltaActions)
    1. [Register Metrics](#run-registerSQLMetrics)
1. [Commit Transaction](#run-commit)
1. [Re-Cache Target Delta Table](#run-recacheByPlan)
1. [Post Metric Updates](#run-postDriverMetricUpdates)

### <span id="run-withNewTransaction"> Begin Transaction

`run` [starts a new transaction](../../DeltaLog.md#withNewTransaction) (on the [target delta table](#targetDeltaLog)).

### <span id="run-canMergeSchema"> schema.autoMerge.enabled

Only when [spark.databricks.delta.schema.autoMerge.enabled](../../configuration-properties/DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property is enabled, `run` [updates the metadata](../../ImplicitMetadataOperation.md#updateMetadata) (of the transaction) with the following:

* [migratedSchema](#migratedSchema) (if defined) or the schema of the [target](#target)
* `isOverwriteMode` flag off
* `rearrangeOnly` flag off

### <span id="run-deltaActions"> FileActions

`run` determines [FileAction](../../FileAction.md)s.

#### <span id="run-writeInsertsOnlyWhenNoMatchedClauses"> Single Insert-Only Merge

For a [single insert-only merge](#isSingleInsertOnly) with [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/DeltaSQLConf.md#MERGE_INSERT_ONLY_ENABLED) configuration property enabled, `run` [writeInsertsOnlyWhenNoMatchedClauses](#writeInsertsOnlyWhenNoMatchedClauses).

#### <span id="run-writeAllChanges"> Other Merges

Otherwise, `run` [finds the files to rewrite](#findTouchedFiles) (i.e., [AddFile](../../AddFile.md)s with the rows that satisfy the merge condition) and uses them to [write out merge changes](#writeAllChanges).

The `AddFile`s are converted into [RemoveFile](../../AddFile.md#remove)s.

`run` gives the `RemoveFile`s and the written-out [FileAction](../../FileAction.md)s.

### <span id="run-registerSQLMetrics"> Register Metrics

`run` [registers](../../SQLMetricsReporting.md#registerSQLMetrics) the [SQL metrics](#metrics) (with the [current transaction](../../OptimisticTransaction.md)).

### <span id="run-commit"> Commit Transaction

`run` [commits](../../OptimisticTransactionImpl.md#commit) the [current transaction](../../OptimisticTransaction.md) (with the [FileActions](#run-deltaActions) and `MERGE` operation).

### <span id="run-recacheByPlan"> Re-Cache Target Delta Table

`run` requests the `CacheManager` to re-cache the [target](#target) plan.

### <span id="run-postDriverMetricUpdates"> Post Metric Updates

In the end, `run` posts the SQL metric updates (as a `SparkListenerDriverAccumUpdates` ([Apache Spark]({{ book.spark_core }}/SparkListenerEvent#SparkListenerDriverAccumUpdates)) Spark event) to `SparkListener`s (incl. Spark UI).

!!! note
    Use `SparkListener` ([Apache Spark]({{ book.spark_core }}/SparkListener)) to intercept `SparkListenerDriverAccumUpdates` events.

### <span id="buildTargetPlanWithFiles"> Building Target Logical Query Plan for AddFiles

```scala
buildTargetPlanWithFiles(
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile]): LogicalPlan
```

`buildTargetPlanWithFiles` creates a DataFrame to represent the given [AddFile](../../AddFile.md)s to access the analyzed logical query plan. `buildTargetPlanWithFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) for the [DeltaLog](../../OptimisticTransaction.md#deltaLog) to [create a DataFrame](../../DeltaLog.md#createDataFrame) (for the [Snapshot](../../OptimisticTransaction.md#snapshot) and the given [AddFile](../../AddFile.md)s).

In the end, `buildTargetPlanWithFiles` creates a `Project` logical operator with `Alias` expressions so the output columns of the analyzed logical query plan (of the `DataFrame` of the `AddFiles`) reference the target's output columns (by name).

!!! note
    The output columns of the target delta table are associated with a [OptimisticTransaction](../../OptimisticTransaction.md) as the [Metadata](../../OptimisticTransactionImpl.md#metadata).

    ```scala
    deltaTxn.metadata.schema
    ```

### <span id="run-exceptions"> Exceptions

`run` throws an `AnalysisException` when the target schema is different than the delta table's (has changed after analysis phase):

```text
The schema of your Delta table has changed in an incompatible way since your DataFrame or DeltaTable object was created. Please redefine your DataFrame or DeltaTable object. Changes:
[schemaDiff]
This check can be turned off by setting the session configuration key spark.databricks.delta.checkLatestSchemaOnRead to false.
```

## <span id="writeInsertsOnlyWhenNoMatchedClauses"> Writing Out Single Insert-Only Merge

```scala
writeInsertsOnlyWhenNoMatchedClauses(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): Seq[FileAction]
```

In the end, `writeInsertsOnlyWhenNoMatchedClauses` returns the [FileAction](../../FileAction.md)s (from [writing out data](../../TransactionalWrite.md#writeFiles)).

`writeInsertsOnlyWhenNoMatchedClauses` is used when:

* `MergeIntoCommand` is [executed](#run) (for [single insert-only merge](#isSingleInsertOnly) with [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/DeltaSQLConf.md#MERGE_INSERT_ONLY_ENABLED) enabled)

### <span id="writeInsertsOnlyWhenNoMatchedClauses-outputCols"> Target Output Columns

`writeInsertsOnlyWhenNoMatchedClauses` gets the names of the output (_target_) columns.

`writeInsertsOnlyWhenNoMatchedClauses` creates a collection of output columns with the target names and the [resolved DeltaMergeActions](DeltaMergeIntoClause.md#resolvedActions) of a single [DeltaMergeIntoInsertClause](#notMatchedClauses) (as `Alias` expressions).

### <span id="writeInsertsOnlyWhenNoMatchedClauses-sourceDF"> Source DataFrame

`writeInsertsOnlyWhenNoMatchedClauses` [creates a UDF](#makeMetricUpdateUDF) to update [numSourceRows](#numSourceRows) metric.

`writeInsertsOnlyWhenNoMatchedClauses` creates a source `DataFrame` for the [source](#source) data with `Dataset.filter`s with the UDF and the [condition](DeltaMergeIntoInsertClause.md#condition) of the [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md) (if defined) or `Literal.TrueLiteral`.

!!! note "Use condition for filter pushdown optimization"
    The [condition](DeltaMergeIntoInsertClause.md#condition) of this single [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md) is pushed down to the [source](#source) when Spark SQL optimizes the query.

### <span id="writeInsertsOnlyWhenNoMatchedClauses-dataSkippedFiles"> Data-Skipped AddFiles

`writeInsertsOnlyWhenNoMatchedClauses` splits conjunctive predicates (`And` expressions) in the [merge condition](#condition) and determines a so-called _targetOnlyPredicates_ (predicates with the [target](#target) columns only). `writeInsertsOnlyWhenNoMatchedClauses` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [filterFiles](../../OptimisticTransactionImpl.md#filterFiles) matching the target-only predicates (that gives [AddFile](../../AddFile.md)s).

!!! note "Merge Condition and Data Skipping"
    The [merge condition](#condition) of this [MergeIntoCommand](MergeIntoCommand.md) is used for [Data Skipping](../../data-skipping/index.md).

### <span id="writeInsertsOnlyWhenNoMatchedClauses-targetDF"> Target DataFrame

`writeInsertsOnlyWhenNoMatchedClauses` creates a target `DataFrame` for the data-skipped `AddFile`s.

### <span id="writeInsertsOnlyWhenNoMatchedClauses-insertDf"> Insert DataFrame

`writeInsertsOnlyWhenNoMatchedClauses` [creates a UDF](#makeMetricUpdateUDF) to update [numTargetRowsInserted](#numTargetRowsInserted) metric.

`writeInsertsOnlyWhenNoMatchedClauses` left-anti joins the source `DataFrame` with the target `DataFrame` on the [merge condition](#condition). `writeInsertsOnlyWhenNoMatchedClauses` selects the output columns and uses `Dataset.filter` with the UDF.

??? note "Demo: Left-Anti Join"

    ```scala
    val source = Seq(0, 1, 2, 3).toDF("id") // (1)!
    val target = Seq(3, 4, 5).toDF("id") // (2)!
    val usingColumns = Seq("id")
    val q = source.join(target, usingColumns, "leftanti")
    ```

    1. Equivalent to `spark.range(4)`

        ```text
        +---+
        | id|
        +---+
        |  0|
        |  1|
        |  2|
        |  3|
        +---+
        ```

    1. Equivalent to `spark.range(3, 6)`

        ```text
        +---+
        | id|
        +---+
        |  3|
        |  4|
        |  5|
        +---+
        ```

    ```text
    scala> q.show
    +---+
    | id|
    +---+
    |  0|
    |  1|
    |  2|
    +---+
    ```

### <span id="writeInsertsOnlyWhenNoMatchedClauses-writeFiles"> writeFiles

`writeInsertsOnlyWhenNoMatchedClauses` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [write out](../../TransactionalWrite.md#writeFiles) the [insertDf](#writeInsertsOnlyWhenNoMatchedClauses-insertDf) (possibly [repartitionIfNeeded](#repartitionIfNeeded) on the [partitionColumns](../../Metadata.md#partitionColumns) of the [target delta table](#targetFileIndex)).

!!! note
    This step triggers a Spark write job (and this active [transaction](../../OptimisticTransaction.md) is marked as [hasWritten](../../TransactionalWrite.md#hasWritten)).

### <span id="writeInsertsOnlyWhenNoMatchedClauses-metrics"> Update Metrics

In the end, `writeInsertsOnlyWhenNoMatchedClauses` updates the [metrics](#metrics).

## <span id="writeAllChanges"> Writing Out Merged Data

```scala
writeAllChanges(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction,
  filesToRewrite: Seq[AddFile]): Seq[FileAction]
```

In the end, `writeAllChanges` returns the [FileAction](../../FileAction.md)s (from [writing out data](../../TransactionalWrite.md#writeFiles)).

---

`writeAllChanges` is used when:

* `MergeIntoCommand` is [executed](#run) (that is neither a [single insert-only merge](#isSingleInsertOnly) nor [spark.databricks.delta.merge.optimizeInsertOnlyMerge.enabled](../../configuration-properties/DeltaSQLConf.md#MERGE_INSERT_ONLY_ENABLED) configuration property is enabled for which [writeInsertsOnlyWhenNoMatchedClauses](#writeInsertsOnlyWhenNoMatchedClauses) is used instead)

### <span id="writeAllChanges-targetOutputCols"> targetOutputCols

`writeAllChanges` builds the target output schema (possibly with some `null`s for the target columns that are not in the current schema).

### <span id="writeAllChanges-newTarget"> newTarget Query Plan

`writeAllChanges` [builds a target logical query plan](#buildTargetPlanWithFiles) for the given `filesToRewrite` [AddFile](../../AddFile.md)s.

### <span id="writeAllChanges-joinType"> Join Type

`writeAllChanges` determines the join type to use:

* `rightOuter` for [matched-only merge](#isMatchedOnly) with [spark.databricks.delta.merge.optimizeMatchedOnlyMerge.enabled](../../configuration-properties/DeltaSQLConf.md#MERGE_MATCHED_ONLY_ENABLED) configuration property enabled
* `fullOuter` otherwise

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges using [joinType] join:
source.output: [outputSet]
target.output: [outputSet]
condition: [condition]
newTarget.output: [outputSet]
```

### <span id="writeAllChanges-sourceDF"> Source DataFrame

`writeAllChanges` creates a source `DataFrame` for the [source](#source) query plan and an extra column:

* `_source_row_present_` with the value of an UDF that increments the [numSourceRowsInSecondScan](#numSourceRowsInSecondScan) metric

### <span id="writeAllChanges-targetDF"> New Target DataFrame

`writeAllChanges` creates a target `DataFrame` for the [newTarget](#writeAllChanges-newTarget) query plan and an extra column:

* `_target_row_present_` with `true` literal

### <span id="writeAllChanges-joinedDF"> Joined DataFrame

`writeAllChanges` creates a joined `DataFrame` that is a `Dataset.join` of the source and new target `DataFrame`s with the given [join condition](#condition) and the [join type](#writeAllChanges-joinType).

### <span id="writeAllChanges-outputRowSchema"> Output Schema

`writeAllChanges` creates an output schema based on [cdcEnabled](../../change-data-feed/CDCReader.md#isCDCEnabledOnTable):

* FIXME

### <span id="writeAllChanges-processor"> Create JoinedRowProcessor

`writeAllChanges` creates a [JoinedRowProcessor](JoinedRowProcessor.md) (that is then used to map over partitions of the [joined DataFrame](#writeAllChanges-joinedDF)).

### <span id="writeAllChanges-outputDF"> Output DataFrame

`writeAllChanges` creates a `DataFrame` for the `joinedPlan` and uses `Dataset.mapPartitions` operator to let the [JoinedRowProcessor](#writeAllChanges-processor) to [processPartition](JoinedRowProcessor.md#processPartition).

`writeAllChanges` drops [_row_dropped_](#ROW_DROPPED_COL) and [_incr_row_count_](#INCR_ROW_COUNT_COL) columns.

`writeAllChanges` prints out the following DEBUG message to the logs:

```text
writeAllChanges: join output plan:
[outputDF.queryExecution]
```

### <span id="writeAllChanges-newFiles"> writeFiles

`writeAllChanges` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) to [write out](../../TransactionalWrite.md#writeFiles) the [insertDf](#writeInsertsOnlyWhenNoMatchedClauses-insertDf) (possibly [repartitioning if needed](#repartitionIfNeeded) on the [partition columns](../../Metadata.md#partitionColumns)).

!!! note
    This step triggers a Spark write job (and this active [transaction](../../OptimisticTransaction.md) is marked as [hasWritten](../../TransactionalWrite.md#hasWritten)).

### <span id="writeAllChanges-metrics"> Update Metrics

In the end, `writeAllChanges` updates the [metrics](#metrics).

## <span id="isSingleInsertOnly"> Single Insert-Only Merge

```scala
isSingleInsertOnly: Boolean
```

`isSingleInsertOnly` holds true when this `MERGE` command is a single `WHEN NOT MATCHED THEN INSERT`:

1. No [MATCHED clauses](#matchedClauses)
1. There is just a single [notMatchedClauses](#notMatchedClauses)

``` sql title="Example: Single Insert-Only Merge"
MERGE INTO merge_demo to
USING merge_demo_source from
ON to.id = from.id
WHEN NOT MATCHED THEN INSERT *;
```

## <span id="isMatchedOnly"> Matched-Only Merge

```scala
isMatchedOnly: Boolean
```

`isMatchedOnly` holds true when this `MERGE` command is `WHEN MATCHED THEN`-only:

1. No [NOT MATCHED clauses](#notMatchedClauses)
1. [MATCHED clauses](#matchedClauses) only

```sql
MERGE INTO merge_demo to
USING merge_demo_source from
ON to.id = from.id
WHEN MATCHED AND to.id < 3 THEN DELETE
WHEN MATCHED THEN UPDATE SET *;
```

## <span id="makeMetricUpdateUDF"> Creating Metric Update UDF

```scala
makeMetricUpdateUDF(
  name: String): Expression
```

`makeMetricUpdateUDF` looks up the performance metric (by `name`) in the [metrics](#metrics).

In the end, `makeMetricUpdateUDF` defines a non-deterministic UDF to increment the metric (when executed).

!!! note
    This `Expression` is used to increment the following performance metrics:

    * [number of source rows](#numSourceRows)
    * [numSourceRowsInSecondScan](#numSourceRowsInSecondScan)
    * [number of target rows rewritten unmodified](#numTargetRowsCopied)
    * [number of deleted rows](#numTargetRowsDeleted)
    * [number of inserted rows](#numTargetRowsInserted)
    * [number of updated rows](#numTargetRowsUpdated)

`makeMetricUpdateUDF` is used when:

* `MergeIntoCommand` is requested to [findTouchedFiles](#findTouchedFiles), [writeInsertsOnlyWhenNoMatchedClauses](#writeInsertsOnlyWhenNoMatchedClauses), [writeAllChanges](#writeAllChanges)

## <span id="notMatchedClauseOutput"> notMatchedClauseOutput

```scala
notMatchedClauseOutput(
  clause: DeltaMergeIntoInsertClause): Seq[Seq[Expression]]
```

`notMatchedClauseOutput` returns the main data output followed by the CDF data output when [cdcEnabled](../../change-data-feed/CDCReader.md#isCDCEnabledOnTable):

```text
(mainDataOutput)
```

or

```text
(mainDataOutput, insertCdcOutput)
```

---

`notMatchedClauseOutput` creates the output (resolved expressions) of the main data based on the following:

1. The `Expression`s from the [DeltaMergeActions](DeltaMergeIntoClause.md#resolvedActions) of the given [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md)
1. `FalseLiteral`
1. The UDF to increment the [numTargetRowsInserted](#numTargetRowsInserted) metric
1. [null](../../change-data-feed/CDCReader.md#CDC_TYPE_NOT_CDC) literal (to indicate the main data not CDF's)

With [cdcEnabled](../../change-data-feed/CDCReader.md#isCDCEnabledOnTable), `notMatchedClauseOutput` creates the output (resolved expressions) of the CDF data based on the following:

1. The `Expression`s from the [DeltaMergeActions](DeltaMergeIntoClause.md#resolvedActions) of the given [DeltaMergeIntoInsertClause](DeltaMergeIntoInsertClause.md)
1. `FalseLiteral`
1. `TrueLiteral`
1. [insert](../../change-data-feed/CDCReader.md#CDC_TYPE_INSERT) literal

!!! note
    The first two expressions are the same in the main data and CDF data outputs.

---

`notMatchedClauseOutput` is used when:

* `MergeIntoCommand` is requested to [write out merged data](#writeAllChanges) (for [notMatchedOutputs](JoinedRowProcessor.md#notMatchedOutputs) to create a [JoinedRowProcessor](JoinedRowProcessor.md) based on the [non-matched insert clauses](#notMatchedClauses))

## <span id="findTouchedFiles"> Finding Files to Rewrite

```scala
findTouchedFiles(
  spark: SparkSession,
  deltaTxn: OptimisticTransaction): Seq[AddFile]
```

!!! important
    `findTouchedFiles` is such a fine piece of art (_a Delta gem_). It uses a custom accumulator, a UDF (to use this accumulator to record touched file names) and `input_file_name()` standard function for the names of the files read.

    It is always worth keeping in mind that Delta Lake uses files for data storage and that is why `input_file_name()` standard function works. It would not work for non-file-based data sources.

??? note "Example 1: Understanding the Internals of `findTouchedFiles`"

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

### <span id="findTouchedFiles-recordTouchedFileName"> recordTouchedFileName

`findTouchedFiles` defines a nondeterministic UDF that adds the file names to the accumulator (_recordTouchedFileName_).

### <span id="findTouchedFiles-dataSkippedFiles"> dataSkippedFiles

`findTouchedFiles` splits conjunctive predicates (`And` binary expressions) in the [condition](#condition) expression and collects the predicates that use the [target](#target)'s columns (_targetOnlyPredicates_). `findTouchedFiles` requests the given [OptimisticTransaction](../../OptimisticTransaction.md) for the [files that match the target-only predicates](../../OptimisticTransactionImpl.md#filterFiles) (and creates a `dataSkippedFiles` collection of [AddFile](../../AddFile.md)s).

!!! note
    This step looks similar to **filter predicate pushdown**.

`findTouchedFiles` creates one `DataFrame` for the [source data](#source) (using [Spark SQL]({{ book.spark_sql }}/Dataset/#ofRows) utility).

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

??? note "Example 2: Understanding the Internals of `findTouchedFiles`"

    ```scala
    val TOUCHED_FILES_ACCUM_NAME = "MergeIntoDelta.touchedFiles"
    val touchedFilesAccum = spark.sparkContext.collectionAccumulator[String](TOUCHED_FILES_ACCUM_NAME)
    val recordTouchedFileName = udf { (fileName: String) => {
      touchedFilesAccum.add(fileName)
      1
    }}.asNondeterministic()
    ```

    ```scala
    val target = "/tmp/parquet"
    spark.range(10).write.save(target)
    ```

    ```scala
    val FILE_NAME_COL = "_file_name_"
    val dataFiles = spark.read.parquet(target).withColumn(FILE_NAME_COL, input_file_name())
    val collectTouchedFiles = dataFiles.select(col(FILE_NAME_COL), recordTouchedFileName(col(FILE_NAME_COL)).as("one"))
    ```

    ```text
    scala> collectTouchedFiles.show(truncate = false)
    +---------------------------------------------------------------------------------------+---+
    |_file_name_                                                                            |one|
    +---------------------------------------------------------------------------------------+---+
    |file:///tmp/parquet/part-00007-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00001-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00006-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00011-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00003-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00014-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00004-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00012-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00009-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    |file:///tmp/parquet/part-00015-76df546f-91f8-4cbb-8fcc-f51478e0db31-c000.snappy.parquet|1  |
    +---------------------------------------------------------------------------------------+---+    
    ```

    ```scala
    import scala.collection.JavaConverters._
    val touchedFileNames = touchedFilesAccum.value.asScala.toSeq
    ```

    Use the Stages tab in web UI to review the accumulator values.

`findTouchedFiles` prints out the following TRACE message to the logs:

```text
findTouchedFiles: matched files:
  [touchedFileNames]
```

`findTouchedFiles` [generateCandidateFileMap](#generateCandidateFileMap) for the [files that match the target-only predicates](#findTouchedFiles-dataSkippedFiles).

`findTouchedFiles` [getTouchedFile](#getTouchedFile) for every touched file name.

`findTouchedFiles` updates the following performance metrics:

* [numTargetFilesBeforeSkipping](#numTargetFilesBeforeSkipping) and adds the [numOfFiles](#numOfFiles) of the [Snapshot](../../OptimisticTransaction.md#snapshot) of the given [OptimisticTransaction](../../OptimisticTransaction.md)
* [numTargetFilesAfterSkipping](#numTargetFilesAfterSkipping) and adds the number of the [files that match the target-only predicates](#findTouchedFiles-dataSkippedFiles)
* [numTargetFilesRemoved](#numTargetFilesRemoved) and adds the number of the touched files

In the end, `findTouchedFiles` gives the touched files (as [AddFile](../../AddFile.md)s).

## <span id="repartitionIfNeeded"> repartitionIfNeeded

```scala
repartitionIfNeeded(
  spark: SparkSession,
  df: DataFrame,
  partitionColumns: Seq[String]): DataFrame
```

`repartitionIfNeeded` repartitions the given `DataFrame` by the `partitionColumns` (using `Dataset.repartition` operation) when all the following hold:

1. There is at least one partition column (among the given `partitionColumns`)
1. [spark.databricks.delta.merge.repartitionBeforeWrite.enabled](../../configuration-properties/DeltaSQLConf.md#MERGE_REPARTITION_BEFORE_WRITE) configuration property is `true`

---

`repartitionIfNeeded` is used when:

* `MergeIntoCommand` is [executed](#run) (and [writes data out](../../TransactionalWrite.md#writeFiles) for [Single Insert-Only Merge](#writeInsertsOnlyWhenNoMatchedClauses) and [other merges](#writeAllChanges))

## LeafRunnableCommand { #LeafRunnableCommand }

`MergeIntoCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand/)) logical operator.

## Demo

[Demo: Merge Operation](../../demo/merge-operation.md)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.commands.MergeIntoCommand` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.MergeIntoCommand.name = org.apache.spark.sql.delta.commands.MergeIntoCommand
logger.MergeIntoCommand.level = all
```

Refer to [Logging](../../logging.md).
