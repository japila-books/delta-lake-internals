# RestoreTableCommand

`RestoreTableCommand` is a [DeltaCommand](../DeltaCommand.md) (and a [RestoreTableCommandBase](RestoreTableCommandBase.md)) to restore a delta table to a specified version or timestamp.

## Creating Instance

`RestoreTableCommand` takes the following to be created:

* <span id="sourceTable"> [DeltaTableV2](../../DeltaTableV2.md)
* <span id="targetIdent"> `TableIdentifier` of the delta table

`RestoreTableCommand` is created when:

* `DeltaAnalysis` logical resolution rule is [executed](../../DeltaAnalysis.md#run) (to resolve a [RestoreTableStatement](RestoreTableStatement.md))

## <span id="run"> run

```scala
run(
  spark: SparkSession): Seq[Row]
```

`run`...FIXME

`run` is part of the `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand#run)) abstraction.
