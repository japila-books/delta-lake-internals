# UpdateCommand

`UpdateCommand` is a [DeltaCommand](../DeltaCommand.md) that represents [DeltaUpdateTable](DeltaUpdateTable.md) logical command at execution.

`UpdateCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) logical operator.

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

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) abstraction.

`run`...FIXME

### <span id="performUpdate"> performUpdate

```scala
performUpdate(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
```

`performUpdate`...FIXME

### <span id="rewriteFiles"> rewriteFiles

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

### <span id="buildUpdatedColumns"> buildUpdatedColumns

```scala
buildUpdatedColumns(
  condition: Expression): Seq[Column]
```

`buildUpdatedColumns`...FIXME
