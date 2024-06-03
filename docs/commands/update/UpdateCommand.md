# UpdateCommand

`UpdateCommand` is a [DeltaCommand](../DeltaCommand.md) that represents [DeltaUpdateTable](DeltaUpdateTable.md) logical command at execution.

`UpdateCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) logical operator.

`UpdateCommand` can use [Deletion Vectors](../../deletion-vectors/index.md) table feature to _soft-delete_ records when [executed](#run) (based on [shouldWritePersistentDeletionVectors](#shouldWritePersistentDeletionVectors)).

## Creating Instance

`UpdateCommand` takes the following to be created:

* <span id="tahoeFileIndex"> [TahoeFileIndex](../../TahoeFileIndex.md)
* <span id="target"> Target Data ([LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="updateExpressions"> Update Expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/))
* <span id="condition"> (optional) Condition Expression ([Spark SQL]({{ book.spark_sql }}/expressions/Expression/))

`UpdateCommand` is created when:

* [PreprocessTableUpdate](../../PreprocessTableUpdate.md) logical resolution rule is executed (and resolves a [DeltaUpdateTable](DeltaUpdateTable.md) logical command)

## Performance Metrics

Name              | web UI
------------------|-------------------------------------------
`numAddedFiles`   | number of files added.
`numRemovedFiles` | number of files removed.
`numUpdatedRows`  | number of rows updated.
`executionTimeMs` | time taken to execute the entire operation
`scanTimeMs`      | time taken to scan the files for matches
`rewriteTimeMs`   | time taken to rewrite the matched files

## <span id="performUpdate"><span id="rewriteFiles"><span id="buildUpdatedColumns"> Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/#run)) abstraction.

`run`...FIXME

### performUpdate

```scala
performUpdate(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
```

`performUpdate`...FIXME

With [persistent Deletion Vectors enabled](#shouldWritePersistentDeletionVectors), `performUpdate`...FIXME and [findTouchedFiles](../../deletion-vectors/DMLWithDeletionVectorsHelper.md#findTouchedFiles).

### rewriteFiles

```scala
rewriteFiles(
  spark: SparkSession,
  txn: OptimisticTransaction,
  rootPath: Path,
  inputLeafFiles: Seq[String],
  nameToAddFileMap: Map[String, AddFile],
  condition: Expression): Seq[FileAction]
```

`rewriteFiles`...FIXME

### buildUpdatedColumns

```scala
buildUpdatedColumns(
  condition: Expression): Seq[Column]
```

`buildUpdatedColumns`...FIXME

## shouldWritePersistentDeletionVectors { #shouldWritePersistentDeletionVectors }

```scala
shouldWritePersistentDeletionVectors(
  spark: SparkSession,
  txn: OptimisticTransaction): Boolean
```

`shouldWritePersistentDeletionVectors` is enabled (`true`) when the following all hold:

1. [spark.databricks.delta.update.deletionVectors.persistent](../../configuration-properties/index.md#update.deletionVectors.persistent) configuration property is enabled (`true`)
1. [Protocol and table configuration support deletion vectors feature](../../deletion-vectors/DeletionVectorUtils.md#deletionVectorsWritable)

---

`shouldWritePersistentDeletionVectors` is used when:

* `UpdateCommand` is [executed](#run) (and [performUpdate](UpdateCommand.md#performUpdate))
