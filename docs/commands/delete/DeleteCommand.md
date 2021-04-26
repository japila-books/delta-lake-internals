# DeleteCommand

`DeleteCommand` is a [DeltaCommand](../DeltaCommand.md) that represents [DeltaDelete](DeltaDelete.md) logical command at execution (and hence `DELETE FROM` SQL statement indirectly).

`DeleteCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand/)) logical operator.

## Creating Instance

`DeleteCommand` takes the following to be created:

* <span id="tahoeFileIndex"> [TahoeFileIndex](../../TahoeFileIndex.md)
* <span id="target"> Target Data ([LogicalPlan]({{ book.spark_sql }}/logical-operators/LogicalPlan/))
* <span id="condition"> Condition ([Expression]({{ book.spark_sql }}/expressions/Expression/))

`DeleteCommand` is created (also using [apply](#apply) factory utility) when:

* [PreprocessTableDelete](../../PreprocessTableDelete.md) logical resolution rule is executed (and resolves a [DeltaDelete](DeltaDelete.md) logical command)

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

`run` requests the [TahoeFileIndex](#tahoeFileIndex) for the [DeltaLog](../../TahoeFileIndex.md#deltaLog) (and [asserts that the table is removable](../../DeltaLog.md#assertRemovable)).

`run` requests the `DeltaLog` to [start a new transaction](../../DeltaLog.md#withNewTransaction) for [performDelete](#performDelete).

In the end, `run` re-caches all cached plans (incl. this relation itself) by requesting the `CacheManager` ([Spark SQL]({{ book.spark_sql }}/CacheManager)) to recache the [target](#target).

### <span id="performDelete"> performDelete

```scala
performDelete(
  sparkSession: SparkSession,
  deltaLog: DeltaLog,
  txn: OptimisticTransaction): Unit
```

#### <span id="performDelete-numFilesTotal"> Number of Table Files

`performDelete` requests the given [DeltaLog](../../DeltaLog.md) for the [current Snapshot](../../DeltaLog.md#snapshot) that is in turn requested for the [number of files](../../Snapshot.md#numOfFiles) in the delta table.

#### <span id="performDelete-deleteActions"> Finding Delete Actions

`performDelete` branches off based on the optional [condition](#condition):

1. [No condition](#performDelete-deleteActions-condition-undefined) to delete the whole table
1. [Condition defined on metadata only](#performDelete-deleteActions-condition-metadata-only)
1. [Other conditions](#performDelete-deleteActions-condition-others)

#### <span id="performDelete-deleteActions-condition-undefined"> Delete Condition Undefined

`performDelete`...FIXME

#### <span id="performDelete-deleteActions-condition-metadata-only"> Metadata-Only Delete Condition

`performDelete`...FIXME

#### <span id="performDelete-deleteActions-condition-others"> Other Delete Conditions

`performDelete`...FIXME

#### <span id="performDelete-deleteActions-nonEmpty"> Delete Actions Available

`performDelete`...FIXME

## <span id="apply"> Creating DeleteCommand

```scala
apply(
  delete: DeltaDelete): DeleteCommand
```

`apply` creates a [DeleteCommand](DeleteCommand.md).
