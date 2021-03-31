# DeleteCommand

`DeleteCommand` is a [Delta command](DeltaCommand.md) that represents [DeltaDelete](DeltaDelete.md) logical command at execution.

`DeleteCommand` is a `RunnableCommand` logical operator ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)).

## Creating Instance

`DeleteCommand` takes the following to be created:

* <span id="tahoeFileIndex"> [TahoeFileIndex](../TahoeFileIndex.md)
* <span id="target"> Target Data ([LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="condition"> Condition ([Expression]({{ book.spark_sql }}/expressions/Expression/))

`DeleteCommand` is created (also using [apply](#apply) factory utility) when:

* [PreprocessTableDelete](../PreprocessTableDelete.md) logical resolution rule is executed (and resolves a [DeltaDelete](DeltaDelete.md) logical command)

## Performance Metrics

Name     | web UI
---------|----------
`numRemovedFiles` | number of files removed.
`numAddedFiles` | number of files added.
`numDeletedRows` | number of rows deleted.

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) abstraction.

`run` requests the [TahoeFileIndex](#tahoeFileIndex) for the [DeltaLog](../TahoeFileIndex.md#deltaLog) (and [asserts that the table is removable](../DeltaLog.md#assertRemovable)).

`run` requests the `DeltaLog` to [start a new transaction](../DeltaLog.md#withNewTransaction) for [performDelete](#performDelete).

In the end, `run` re-caches all cached plans (incl. this relation itself) by requesting the `CacheManager` ([Spark SQL]({{ book.spark_sql }}/CacheManager)) to recache the [target](#target).

### <span id="performDelete"> performDelete

```scala
performDelete(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
```

`performDelete`...FIXME

## <span id="apply"> Creating DeleteCommand

```scala
apply(
  delete: DeltaDelete): DeleteCommand
```

`apply` creates a [DeleteCommand](DeleteCommand.md).
