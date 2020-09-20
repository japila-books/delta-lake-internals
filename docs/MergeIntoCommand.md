# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](DeltaCommand.md) that represents a [DeltaMergeInto](DeltaMergeInto.md) logical command.

`MergeIntoCommand` is a logical command (Spark SQL's [RunnableCommand](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/RunnableCommand/)).

## Performance Metrics

Name     | web UI
---------|----------
`numSourceRows` | number of source rows
`numTargetRowsCopied` | number of target rows rewritten unmodified
`numTargetRowsInserted` | number of inserted rows
`numTargetRowsUpdated` | number of updated rows
`numTargetRowsDeleted` | number of deleted rows
`numTargetFilesBeforeSkipping` | number of target files before skipping
`numTargetFilesAfterSkipping` | number of target files after skipping
`numTargetFilesRemoved` | number of files removed to target
`numTargetFilesAdded` | number of files added to target

## Creating Instance

`MergeIntoCommand` takes the following to be created:

* <span id="source"> Source Data (`LogicalPlan`)
* <span id="target"> Target Data (`LogicalPlan`)
* <span id="targetFileIndex"> [TahoeFileIndex](TahoeFileIndex.md)
* <span id="condition"> Condition Expression
* <span id="matchedClauses"> Matched Clauses (`Seq[DeltaMergeIntoMatchedClause]`)
* <span id="notMatchedClause"> Optional Non-Matched Clause (`Option[DeltaMergeIntoInsertClause]`)
* <span id="migratedSchema"> Migrated Schema

`MergeIntoCommand` is created when [PreprocessTableMerge](PreprocessTableMerge.md) logical resolution rule is executed (on a [DeltaMergeInto](DeltaMergeInto.md) logical command).

## <span id="run"> Executing Command

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run` requests the [target DeltaLog](#targetDeltaLog) to [start a new transaction](DeltaLog.md#withNewTransaction).

With [spark.databricks.delta.schema.autoMerge.enabled](DeltaSQLConf.md#DELTA_SCHEMA_AUTO_MIGRATE) configuration property enabled, `run` [updates the metadata](ImplicitMetadataOperation.md#updateMetadata) (of the transaction).

<span id="run-deltaActions">
`run` determines Delta actions ([RemoveFile](RemoveFile.md)s and [AddFile](AddFile.md)s).

??? todo "Describe `deltaActions` part"

With [spark.databricks.delta.history.metricsEnabled](DeltaSQLConf.md#DELTA_HISTORY_METRICS_ENABLED) configuration property enabled, `run` requests the [current transaction](OptimisticTransaction.md) to [register SQL metrics for the Delta operation](SQLMetricsReporting.md#registerSQLMetrics).

`run` requests the [current transaction](OptimisticTransaction.md) to [commit](OptimisticTransactionImpl.md#commit) (with the [Delta actions](#run-deltaActions) and `Merge` operation).

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
`writeAllChanges` [buildTargetPlanWithFiles](#buildTargetPlanWithFiles).

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

`writeAllChanges` requests the input [OptimisticTransaction](OptimisticTransaction.md) to [writeFiles](TransactionalWrite.md#writeFiles) (possibly repartitioning by the partition columns if table is partitioned and [spark.databricks.delta.merge.repartitionBeforeWrite.enabled](DeltaSQLConf.md#MERGE_REPARTITION_BEFORE_WRITE) configuration property is enabled).

`writeAllChanges` is used when `MergeIntoCommand` is requested to [run](#run).

### <span id="findTouchedFiles"> findTouchedFiles

```scala
findTouchedFiles(
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile]): LogicalPlan
```

`findTouchedFiles`...FIXME

`findTouchedFiles` is used when `MergeIntoCommand` is requested to [run](#run).

### <span id="buildTargetPlanWithFiles"> buildTargetPlanWithFiles

```scala
buildTargetPlanWithFiles(
  deltaTxn: OptimisticTransaction,
  files: Seq[AddFile]): LogicalPlan
```

`buildTargetPlanWithFiles`...FIXME

`buildTargetPlanWithFiles` is used when `MergeIntoCommand` is requested to [run](#run) (via [findTouchedFiles](#findTouchedFiles) and [writeAllChanges](#writeAllChanges)).
