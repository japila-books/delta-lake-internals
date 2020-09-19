# MergeIntoCommand

`MergeIntoCommand` is a [DeltaCommand](DeltaCommand.md).

`MergeIntoCommand` is a logical command (Spark SQL's [RunnableCommand](https://jaceklaskowski.github.io/mastering-spark-sql-book/logical-operators/RunnableCommand/)).

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

`writeAllChanges`...FIXME

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
