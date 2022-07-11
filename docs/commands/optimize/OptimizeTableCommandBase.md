# OptimizeTableCommandBase

`OptimizeTableCommandBase` is a (marker) extension of the [DeltaCommand](../DeltaCommand.md) abstraction for [optimize commands](#implementations).

`OptimizeTableCommandBase` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)).

## Implementations

* [OptimizeTableCommand](OptimizeTableCommand.md)

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is part of the `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command#output)) abstraction.

Name | DataType
-----|---------
 `path` | `StringType`
 `metrics` | [OptimizeMetrics](OptimizeMetrics.md)

## <span id="validateZorderByColumns"> validateZorderByColumns

```scala
validateZorderByColumns(
  spark: SparkSession,
  deltaLog: DeltaLog,
  unresolvedZOrderByCols: Seq[UnresolvedAttribute]): Unit
```

`validateZorderByColumns`...FIXME

`validateZorderByColumns` is used when:

* [OptimizeTableCommand](OptimizeTableCommand.md) is executed
