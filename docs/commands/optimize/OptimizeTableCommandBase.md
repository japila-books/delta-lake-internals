# OptimizeTableCommandBase

`OptimizeTableCommandBase` is a (marker) extension of the [DeltaCommand](../DeltaCommand.md) abstraction for [optimize commands](#implementations).

`OptimizeTableCommandBase` is a `RunnableCommand` ([Spark SQL]({{ book.spark_sql }}/logical-operators/RunnableCommand)).

## Implementations

* [OptimizeTableCommand](OptimizeTableCommand.md)

## Output Attributes { #output }

```scala
output: Seq[Attribute]
```

`output` is part of the `Command` ([Spark SQL]({{ book.spark_sql }}/logical-operators/Command#output)) abstraction.

Name | DataType
-----|---------
 `path` | `StringType`
 `metrics` | [OptimizeMetrics](OptimizeMetrics.md)

## Validating zOrderBy Columns { #validateZorderByColumns }

```scala
validateZorderByColumns(
  spark: SparkSession,
  deltaLog: DeltaLog,
  unresolvedZOrderByCols: Seq[UnresolvedAttribute]): Unit
```

??? warning "Procedure"
    `validateZorderByColumns` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

    It is mainly to throw an exception when things are not as expected for the [OPTIMIZE](index.md) command.

`validateZorderByColumns` does nothing (and returns) when there is no `unresolvedZOrderByCols` columns specified.

`validateZorderByColumns` makes sure that no `unresolvedZOrderByCols` column violates the following requirements (or throws `DeltaIllegalArgumentException` or `DeltaAnalysisException`):

1. It is part of [data schema](../../Metadata.md#dataSchema)
1. [Column statistics](../../StatisticsCollection.md#statCollectionSchema) are available for the column (when [spark.databricks.delta.optimize.zorder.checkStatsCollection.enabled](../../configuration-properties/index.md#optimize.zorder.checkStatsCollection.enabled) enabled)
1. It is not a [partition column](../../Metadata.md#partitionColumns) (as Z-Ordering can only be performed on data columns)

---

`validateZorderByColumns` is used when:

* `OptimizeTableCommand` is [executed](OptimizeTableCommand.md#run)
