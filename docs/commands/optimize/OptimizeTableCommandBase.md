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

## <span id="validateZorderByColumns"> Validating zOrderBy Columns

```scala
validateZorderByColumns(
  spark: SparkSession,
  deltaLog: DeltaLog,
  unresolvedZOrderByCols: Seq[UnresolvedAttribute]): Unit
```

!!! note
    Since `validateZorderByColumns` returns `Unit` (no value to work with), I'm sure you have already figured out that it is mainly to throw an exception when things are not as expected for the [OPTIMIZE](index.md) command.

`validateZorderByColumns` does nothing (and returns) when there is no `unresolvedZOrderByCols` columns specified.

`validateZorderByColumns` makes sure that no `unresolvedZOrderByCols` column violates the following requirements (or throws `DeltaIllegalArgumentException` or `DeltaAnalysisException`):

1. It is part of [data schema](../../Metadata.md#dataSchema)
1. [Column statistics](../../StatisticsCollection.md#statCollectionSchema) are available for the column (when [spark.databricks.delta.optimize.zorder.checkStatsCollection.enabled](../../configuration-properties/DeltaSQLConf.md#DELTA_OPTIMIZE_ZORDER_COL_STAT_CHECK) enabled)
1. It is not a [partition column](../../Metadata.md#partitionColumns) (as Z-Ordering can only be performed on data columns)

`validateZorderByColumns` is used when:

* `OptimizeTableCommand` is [executed](OptimizeTableCommand.md#run)
