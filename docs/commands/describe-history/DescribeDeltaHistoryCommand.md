# DescribeDeltaHistoryCommand

`DescribeDeltaHistoryCommand` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)) that uses [DeltaHistoryManager](../../DeltaHistoryManager.md) for the [commit history](../../DeltaHistoryManager.md#getHistory) of a delta table.

`DescribeDeltaHistoryCommand` is used for [DESCRIBE HISTORY](../../sql/index.md#DESCRIBE-HISTORY) SQL command.

## Creating Instance

`DescribeDeltaHistoryCommand` takes the following to be created:

* <span id="path"> (optional) Directory
* <span id="tableIdentifier"> (optional) `TableIdentifier`
* <span id="limit"> (optional) Number of commits to display
* <span id="output"> Output Attributes (default: [CommitInfo](../../CommitInfo.md))

`DescribeDeltaHistoryCommand` is created for:

* [DESCRIBE HISTORY](../../sql/index.md#DESCRIBE-HISTORY) SQL command (that uses `DeltaSqlAstBuilder` to [parse DESCRIBE HISTORY SQL command](../../sql/DeltaSqlAstBuilder.md#visitDescribeDeltaHistory))

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.

`run` creates a Hadoop `Path` to (the location of) the delta table (based on [DeltaTableIdentifier](../../DeltaTableIdentifier.md)).

`run` creates a [DeltaLog](../../DeltaLog.md#forTable) for the delta table.

`run` requests the `DeltaLog` for the [DeltaHistoryManager](../../DeltaLog.md#history) that is requested for the [commit history](../../DeltaHistoryManager.md#getHistory).
