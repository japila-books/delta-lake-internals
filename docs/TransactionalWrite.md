# TransactionalWrite

`TransactionalWrite` is an [abstraction](#contract) of [optimistic transactional writers](#implementations) that can [write a structured query out](#writeFiles) to a [Delta table](#deltaLog).

## Contract

### DeltaLog { #deltaLog }

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md) (of a delta table) that this transaction is changing

Used when:

* `OptimisticTransactionImpl` is requested to [prepare a commit](OptimisticTransactionImpl.md#prepareCommit), [doCommit](OptimisticTransactionImpl.md#doCommit), [checkAndRetry](OptimisticTransactionImpl.md#checkAndRetry), and [perform post-commit operations](OptimisticTransactionImpl.md#postCommit) (and execute [delta log checkpoint](checkpoints/Checkpoints.md#checkpoint))
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed
* `DeltaCommand` is requested to [buildBaseRelation](commands/DeltaCommand.md#buildBaseRelation) and [commitLarge](commands/DeltaCommand.md#commitLarge)
* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed
* `TransactionalWrite` is requested to [write a structured query out to a delta table](#writeFiles)
* [GenerateSymlinkManifest](post-commit-hooks/GenerateSymlinkManifest.md) post-commit hook is executed
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)
* `DeltaSink` is requested to [addBatch](delta/DeltaSink.md#addBatch)

### Metadata { #metadata }

```scala
metadata: Metadata
```

[Metadata](Metadata.md) (of the [delta table](#deltaLog)) that this transaction is changing

### Protocol { #protocol }

```scala
protocol: Protocol
```

[Protocol](Protocol.md) (of the [delta table](#deltaLog)) that this transaction is changing

Used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](OptimisticTransactionImpl.md#updateMetadata), [verifyNewMetadata](OptimisticTransactionImpl.md#verifyNewMetadata) and [prepareCommit](OptimisticTransactionImpl.md#prepareCommit)
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed

### Snapshot { #snapshot }

```scala
snapshot: Snapshot
```

[Snapshot](Snapshot.md) (of the [delta table](#deltaLog)) that this transaction is [reading at](OptimisticTransactionImpl.md#readVersion)

## Implementations

* [OptimisticTransaction](OptimisticTransaction.md)

## spark.databricks.delta.history.metricsEnabled { #history.metricsEnabled }

With [spark.databricks.delta.history.metricsEnabled](configuration-properties/DeltaSQLConf.md#DELTA_HISTORY_METRICS_ENABLED) configuration property enabled, `TransactionalWrite` creates a `BasicWriteJobStatsTracker` ([Spark SQL]({{ book.spark_sql }}/datasources/BasicWriteJobStatsTracker)) and [registers SQL metrics](SQLMetricsReporting.md#registerSQLMetrics) (when requested to [write data out](#writeFiles)).

## hasWritten Flag { #hasWritten }

```scala
hasWritten: Boolean = false
```

`TransactionalWrite` uses `hasWritten` internal registry to prevent `OptimisticTransactionImpl` from [updating metadata](OptimisticTransactionImpl.md#updateMetadata) after [writting data out](#writeFiles).

`hasWritten` is initially `false` and changes to `true` after [data is written out](#writeFiles).

## Writing Data Out { #writeFiles }

```scala
writeFiles(
  data: Dataset[_]): Seq[FileAction]  // (1)!
writeFiles(
  data: Dataset[_],
  writeOptions: Option[DeltaOptions]): Seq[FileAction]  // (3)!
writeFiles(
  inputData: Dataset[_],
  writeOptions: Option[DeltaOptions],
  additionalConstraints: Seq[Constraint]): Seq[FileAction]
writeFiles(
  data: Dataset[_],
  additionalConstraints: Seq[Constraint]): Seq[FileAction]  // (2)!
```

1. Uses no [Constraint](constraints/Constraint.md)s
2. Uses no write-related [DeltaOptions](delta/DeltaOptions.md)
3. Uses no [Constraint](constraints/Constraint.md)s

`writeFiles` writes the given `data` (as a `Dataset`) to a [delta table](#deltaLog) and returns [AddFile](AddFile.md)s with [AddCDCFile](AddCDCFile.md)s (from the [DelayedCommitProtocol](#writeFiles-committer)).

---

`writeFiles` is used when:

* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write)
* `DeleteCommand` is requested to [rewriteFiles](commands/delete/DeleteCommand.md#rewriteFiles)
* `MergeIntoCommand` is requested to [writeInsertsOnlyWhenNoMatchedClauses](commands/merge/MergeIntoCommand.md#writeInsertsOnlyWhenNoMatchedClauses) and [writeAllChanges](commands/merge/MergeIntoCommand.md#writeAllChanges)
* `OptimizeExecutor` is requested to [runOptimizeBinJob](commands/optimize/OptimizeExecutor.md#runOptimizeBinJob)
* `UpdateCommand` is requested to [rewriteFiles](commands/update/UpdateCommand.md#rewriteFiles)
* `DeltaSink` is requested to [add a streaming micro-batch](delta/DeltaSink.md#addBatch)

---

`writeFiles` creates a [DeltaInvariantCheckerExec](constraints/DeltaInvariantCheckerExec.md) and a [DelayedCommitProtocol](DelayedCommitProtocol.md) to write out files to the [data path](DeltaLog.md#dataPath) (of the [DeltaLog](#deltaLog)).

??? tip "FileFormatWriter"
    `writeFiles` uses `FileFormatWriter` ([Spark SQL]({{ book.spark_sql }}/FileFormatWriter)) utility to write out a result of a streaming query.

`writeFiles` is executed within `SQLExecution.withNewExecutionId`.

??? tip "SQLAppStatusListener"
    `writeFiles` can be tracked using web UI or `SQLAppStatusListener` (using `SparkListenerSQLExecutionStart` and `SparkListenerSQLExecutionEnd` events).

    Learn about [SQLAppStatusListener]({{ book.spark_sql }}/SQLAppStatusListener) in [The Internals of Spark SQL]({{ book.spark_sql }}) online book.

In the end, `writeFiles` returns the [addedStatuses](DelayedCommitProtocol.md#addedStatuses) of the [DelayedCommitProtocol](#writeFiles-committer) committer.

### Step 1. Mark Write Executed { #writeFiles-hasWritten }

Even though it is so early, `writeFiles` turns the [hasWritten](#hasWritten) flag on (`true`).

!!! note
    After `writeFiles`, no [metadata updates](OptimisticTransactionImpl.md#updateMetadata-AssertionError-hasWritten) in the transaction are permitted.

`writeFiles` [performs CDC augmentation](#performCDCPartition) (for the delta table with [Change Data Feed enabled](change-data-feed/CDCReader.md#isCDCEnabledOnTable)).

`writeFiles` [normalizes](#normalizeData) the output dataset (based on the given [DeltaOptions](delta/DeltaOptions.md)).

### Step 2. Partitioning Columns { #writeFiles-partitioningColumns }

`writeFiles` [determines the partitioning columns](#getPartitioningColumns) of the data(set) to be written out.

### Step 3. DelayedCommitProtocol Committer { #writeFiles-committer }

`writeFiles` [creates a DelayedCommitProtocol committer](#getCommitter) for the [data path](DeltaLog.md#dataPath) of the [delta table](#deltaLog).

### Step 4. DeltaJobStatisticsTracker { #writeFiles-optionalStatsTracker }

`writeFiles` may or may not [create a DeltaJobStatisticsTracker](#getOptionalStatsTrackerAndStatsCollection) based on [stats.collect](configuration-properties/index.md#stats.collect) configuration property.

### Step 5. Constraints { #writeFiles-constraints }

`writeFiles` collects [Constraint](constraints/Constraint.md)s:

1. From the [table metadata](constraints/Constraints.md#getAll) ([CHECK constraints](check-constraints/index.md) and [Column Invariants](column-invariants/index.md))
1. [Generated Columns](generated-columns/index.md) (from [normalization](#normalizeData))
1. The given additional [Constraint](constraints/Constraint.md)s

### Step 6. New deltaTransactionalWrite Execution ID { #writeFiles-deltaTransactionalWrite }

`writeFiles` requests a new execution ID ([Spark SQL]({{ book.spark_sql }}/SQLExecution/#withNewExecutionId)) with `deltaTransactionalWrite` name to execute a Spark write job.

!!! note "FileFormatWriter"
    Delta Lake uses [Spark SQL]({{ book.spark_sql }}/connectors/FileFormatWriter/#write) infrastructure to write data out.

### Step 6.1 No Custom Partitioning { #writeFiles-outputSpec }

`writeFiles` uses a `FileFormatWriter.OutputSpec` with no custom partition locations.

### Step 6.2 DeltaInvariantCheckerExec { #writeFiles-physicalPlan }

`writeFiles` creates a [DeltaInvariantCheckerExec](constraints/DeltaInvariantCheckerExec.md) unary physical operator (with the executed plan of the normalized query execution as the child operator and the [constraints](#writeFiles-constraints)).

!!! note
    The `DeltaInvariantCheckerExec` physical operator is later used as the physical plan to for the [data to be written out](#writeFiles-FileFormatWriter).

### Step 6.3 BasicWriteJobStatsTracker { #writeFiles-statsTrackers }

`writeFiles` may or may not create a `BasicWriteJobStatsTracker` ([Spark SQL]({{ book.spark_sql }}/connectors/BasicWriteJobStatsTracker/)) based on [history.metricsEnabled](configuration-properties/index.md#history.metricsEnabled) configuration property.

With [history.metricsEnabled](configuration-properties/index.md#history.metricsEnabled) enabled (and `BasicWriteJobStatsTracker` created), `writeFiles` [registers](SQLMetricsReporting.md#registerSQLMetrics) the following metrics to be collected (_tracked_):

Metric Name | UI Description
------------|---------------
 `numFiles` | number of written files
 `numOutputBytes` | written output
 `numOutputRows` | number of output rows
 `numParts` | number of dynamic part
 `jobCommitTime` | job commit time

### Step 6.4 Write Options { #writeFiles-options }

`writeFiles` makes sure (_filters out_) that there are only the following [write options](delta/DeltaOptions.md) used (from the given `writeOptions`), if specified:

* [compression](delta/DeltaOptions.md#COMPRESSION)
* [maxRecordsPerFile](delta/DeltaOptions.md#MAX_RECORDS_PER_FILE)

### Step 6.5 FileFormatWriter { #writeFiles-FileFormatWriter }

As the very last step within the scope of the [new execution ID](#writeFiles-deltaTransactionalWrite), `writeFiles` writes out the data (using [Spark SQL]({{ book.spark_sql }}/connectors/FileFormatWriter/#write) infrastructure).

??? tip "Logging"
    Enable `ALL` logging level for [org.apache.spark.sql.execution.datasources.FileFormatWriter]({{ book.spark_sql }}/connectors/FileFormatWriter#logging) logger to see what happens inside.

`writeFiles` uses the following (among the others):

* [DeltaInvariantCheckerExec](#writeFiles-physicalPlan) as the physical plan
* The [partitioning columns](#writeFiles-partitioningColumns)
* No bucketing
* [DeltaJobStatisticsTracker](#writeFiles-optionalStatsTracker) and [BasicWriteJobStatsTracker](#writeFiles-statsTrackers)

### Step 7. AddFiles and AddCDCFiles { #writeFiles-FileActions }

In the end, `writeFiles` returns [AddFile](AddFile.md)s and [AddCDCFile](AddCDCFile.md)s (from the [DelayedCommitProtocol](#writeFiles-committer)).

### getOptionalStatsTrackerAndStatsCollection { #getOptionalStatsTrackerAndStatsCollection }

```scala
getOptionalStatsTrackerAndStatsCollection(
  output: Seq[Attribute],
  outputPath: Path,
  partitionSchema: StructType, data: DataFrame): (Option[DeltaJobStatisticsTracker], Option[StatisticsCollection])
```

??? note "Noop with spark.databricks.delta.stats.collect disabled"
    `getOptionalStatsTrackerAndStatsCollection` returns neither [DeltaJobStatisticsTracker](DeltaJobStatisticsTracker.md) nor [StatisticsCollection](StatisticsCollection.md) with [spark.databricks.delta.stats.collect](configuration-properties/index.md#DELTA_COLLECT_STATS) disabled.

`getOptionalStatsTrackerAndStatsCollection` [getStatsSchema](#getStatsSchema) (for the given `output` and `partitionSchema`).

`getOptionalStatsTrackerAndStatsCollection` reads the value of [delta.dataSkippingNumIndexedCols](DeltaConfigs.md#DATA_SKIPPING_NUM_INDEXED_COLS) table property (from the [Metadata](OptimisticTransactionImpl.md#metadata)).

`getOptionalStatsTrackerAndStatsCollection` creates a [StatisticsCollection](StatisticsCollection.md) (with the [tableDataSchema](StatisticsCollection.md#tableDataSchema) based on [spark.databricks.delta.stats.collect.using.tableSchema](configuration-properties/DeltaSQLConf.md#DELTA_COLLECT_STATS_USING_TABLE_SCHEMA) configuration property).

`getOptionalStatsTrackerAndStatsCollection` [getStatsColExpr](#getStatsColExpr) for the `statsDataSchema` and the `StatisticsCollection`.

In the end, `getOptionalStatsTrackerAndStatsCollection` creates a [DeltaJobStatisticsTracker](DeltaJobStatisticsTracker.md) and the `StatisticsCollection`.

#### getStatsColExpr { #getStatsColExpr }

```scala
getStatsColExpr(
  statsDataSchema: Seq[Attribute],
  statsCollection: StatisticsCollection): Expression
```

`getStatsColExpr` creates a `Dataset` for a `LocalRelation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LocalRelation)) logical operator with the given `statsDataSchema`.

`getStatsColExpr` uses `Dataset.select` to execute `to_json` standard function with [statsCollector](StatisticsCollection.md#statsCollector) column.

In the end, `getStatsColExpr` takes the first `Expression` (from the expressions) in the `analyzed` logical query plan.

## <span id="getCommitter"> Creating FileCommitProtocol Committer

```scala
getCommitter(
  outputPath: Path): DelayedCommitProtocol
```

`getCommitter` creates a new [DelayedCommitProtocol](DelayedCommitProtocol.md) with the `delta` job ID and the given `outputPath` (and no random prefix length).

!!! note
    The [DelayedCommitProtocol](DelayedCommitProtocol.md) is used for `FileFormatWriter` ([Spark SQL]({{ book.spark_sql }}/datasources/FileFormatWriter#write)) to write data out and, in the end, for the [addedStatuses](DelayedCommitProtocol.md#addedStatuses) and [changeFiles](DelayedCommitProtocol.md#changeFiles).

`getCommitter` is used when:

* `TransactionalWrite` is requested to [write data out](#writeFiles)

## <span id="getPartitioningColumns"> getPartitioningColumns

```scala
getPartitioningColumns(
  partitionSchema: StructType,
  output: Seq[Attribute],
  colsDropped: Boolean): Seq[Attribute]
```

`getPartitioningColumns`...FIXME

## <span id="normalizeData"> normalizeData

```scala
normalizeData(
  deltaLog: DeltaLog,
  data: Dataset[_]): (QueryExecution, Seq[Attribute], Seq[Constraint], Set[String])
```

`normalizeData` [normalizes the column names](SchemaUtils.md#normalizeColumnNames) (using the [table schema](Metadata.md#schema) of the [Metadata](OptimisticTransactionImpl.md#metadata) and the given `data`).

`normalizeData` [tableHasDefaultExpr](ColumnWithDefaultExprUtils.md#tableHasDefaultExpr) (using the [Protocol](OptimisticTransactionImpl.md#protocol) and the [Metadata](OptimisticTransactionImpl.md#metadata)).

`normalizeData`...FIXME

---

`normalizeData` is used when:

* `TransactionalWrite` is requested to [write data out](#writeFiles)

## <span id="makeOutputNullable"> makeOutputNullable

```scala
makeOutputNullable(
  output: Seq[Attribute]): Seq[Attribute]
```

`makeOutputNullable`...FIXME

## performCDCPartition { #performCDCPartition }

```scala
performCDCPartition(
  inputData: Dataset[_]): (DataFrame, StructType)
```

`performCDCPartition` returns the input `inputData` with or without [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) extra partition column based on whether [Change Data Feed is enabled](change-data-feed/CDCReader.md#isCDCEnabledOnTable) for the table and [_change_type](change-data-feed/CDCReader.md#CDC_TYPE_COLUMN_NAME) column is available in the schema of the given `inputData` or not.

The value of the [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) extra column is as follows:

* `true` for non-null `_change_type`s
* `false` otherwise

The schema (the `StructType` of the tuple to be returned) includes the [__is_cdc](change-data-feed/CDCReader.md#CDC_PARTITION_COL) extra column as the first column (followed by the [physicalPartitionSchema](Metadata.md#physicalPartitionSchema)).
