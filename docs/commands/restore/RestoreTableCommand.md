# RestoreTableCommand

`RestoreTableCommand` is a [DeltaCommand](../DeltaCommand.md) to restore a [delta table](#sourceTable) to a specified version or timestamp.

`RestoreTableCommand` is transactional (and [starts a new transaction](../../DeltaLog.md#withNewTransaction) when [executed](#run)).

## Creating Instance

`RestoreTableCommand` takes the following to be created:

* <span id="sourceTable"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="targetIdent"> `TableIdentifier` of the delta table

`RestoreTableCommand` is created when:

* `DeltaAnalysis` logical resolution rule is [executed](../../DeltaAnalysis.md#run) (to resolve a [RestoreTableStatement](RestoreTableStatement.md))

## <span id="RestoreTableCommandBase"> RestoreTableCommandBase

`RestoreTableCommand` is a [RestoreTableCommandBase](RestoreTableCommandBase.md).

## <span id="LeafRunnableCommand"> LeafRunnableCommand

`RestoreTableCommand` is a `LeafRunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/LeafRunnableCommand)).

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is the [outputSchema](RestoreTableCommandBase.md#outputSchema).

`output` is part of the `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command#output)) abstraction.

## <span id="run"> Executing Command

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run` requests the [DeltaTableV2](#sourceTable) for the [DeltaLog](../../DeltaTableV2.md#deltaLog).

`run` requests the [DeltaTableV2](#sourceTable) for the [DeltaTimeTravelSpec](../../DeltaTableV2.md#timeTravelOpt) to access the [version](../../DeltaTimeTravelSpec.md#version).

!!! note
    `RestoreTableCommand` does not even bother itself to check if the optional [DeltaTimeTravelSpec](../../DeltaTableV2.md#timeTravelOpt) (of the [DeltaTableV2](#sourceTable)) is defined or not.
    It is assumed that it is available and so is the [version](../../DeltaTimeTravelSpec.md#version).

    It is unlike the [timestamp](#getTimestamp). _Why?!_

`run` [retrieves the timestamp (if defined)](#getTimestamp).

`run` determines the version to restore based on the version or the timestamp (whatever defined). For the timestamp, `run` resolves the version by requesting the `DeltaLog` for the [DeltaHistoryManager](../../DeltaLog.md#history) that in turn is requested for the [active commit at that timestamp](../../DeltaHistoryManager.md#getActiveCommitAtTime) (with the `canReturnLastCommit` flag enabled).

??? note "Either the version or timestamp should be provided for restore"
    `run` asserts that either the version or timestamp are provided or throws an `IllegalArgumentException`:

    ```text
    Either the version or timestamp should be provided for restore
    ```

`run` requests the `DeltaLog` to [update](../../SnapshotManagement.md#update) to find the latest version.

??? note "Version to restore should be less then last available version"
    `run` requires that the latest version of the delta table is higher than the requested version to restore or throws an `IllegalArgumentException`:

    ```text
    Version to restore ([versionToRestore])should be less then last available version ([latestVersion])
    ```

    NB: You're right that there are a few typos in the exception message.

`run` requests the `DeltaLog` to [start a new transaction](../../DeltaLog.md#withNewTransaction) and does the _heavy lifting_.

`run` requests the `OptimisticTransaction` for the latest (current) [Snapshot](../../OptimisticTransaction.md#snapshot).

`run` requests the `DeltaLog` for the [Snapshot](../../SnapshotManagement.md#update) at the version to restore (_snapshot to restore to_) and reconciles them using [all the files](../../Snapshot.md#allFiles) (in the snapshots).

??? note "Dataset[AddFile]"
    [All the files](../../Snapshot.md#allFiles) are `Dataset[AddFile]`s.

`run` determines `filesToAdd` (as `Dataset[AddFile]`). `run` uses `left_anti` join on the `Dataset[AddFile]` of the snapshot to restore to with the current snapshot on `path` column. `run` marks the `AddFile`s (in the joined `Dataset[AddFile]`) as [dataChange](../../AddFile.md#dataChange).

??? note "No Spark job started yet"
    No Spark job is started yet as `run` is only preparing it.

`run` determines `filesToRemove` (as `Dataset[RemoveFile]`). `run` uses `left_anti` join on the `Dataset[AddFile]` of the current snapshot with the snapshot to restore to on `path` column. `run` marks the `AddFile`s (in the joined `Dataset[AddFile]`) to be [removed with the current timestamp](../../AddFile.md#removeWithTimestamp).

??? note "No Spark job started yet"
    No Spark job is started yet as `run` is only preparing it.

`run` [checkSnapshotFilesAvailability](#checkSnapshotFilesAvailability) when `spark.sql.files.ignoreMissingFiles` ([Spark SQL]({{ book.spark_sql }}/configuration-properties/#spark.sql.files.ignoreMissingFiles)) configuration property is enabled.

??? note "spark.sql.files.ignoreMissingFiles"
    `spark.sql.files.ignoreMissingFiles` is disabled by default.

`run` [computeMetrics](#computeMetrics) (as a [metrics](#withDescription) Spark job).

??? note "2 Spark Jobs Submitted"
    [computeMetrics](#computeMetrics) submits 2 aggregations that give 2 Spark jobs submitted.

`run` creates a local (Scala) iterator over the `filesToAdd` dataset (as a [add actions](#withDescription) Spark job).

??? note "Local Scala Iterator is Multiple Spark Jobs"
    `run` uses `Dataset.toLocalIterator` ([Spark SQL]({{ book.spark_sql }}/Dataset/#toLocalIterator)) action that triggers multiple jobs.

`run` creates a local (Scala) iterator over the `filesToRemove` dataset (as a [remove actions](#withDescription) Spark job).

`run` requests the `OptimisticTransaction` to [update the metadata](../../OptimisticTransactionImpl.md#updateMetadata) to the [Metadata](../../Metadata.md) of the snapshot to restore to.

`run` [commitLarge](../DeltaCommand.md#commitLarge) the current transaction with the following:

* [AddFile](../../AddFile.md)s and [RemoveFile](../../RemoveFile.md)s
* `DeltaOperations.Restore`

In the end, `run` returns the [metrics](#computeMetrics).

---

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

### <span id="getTimestamp"> getTimestamp

```scala
getTimestamp(): Option[String]
```

`getTimestamp`...FIXME
