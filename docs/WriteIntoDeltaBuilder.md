# WriteIntoDeltaBuilder

`WriteIntoDeltaBuilder` is a `WriteBuilder` ([Spark SQL]({{ book.spark_sql }}/connector/WriteBuilder)) with support for the following capabilities:

* `SupportsOverwrite` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsOverwrite))
* `V1WriteBuilder` ([Spark SQL]({{ book.spark_sql }}/connector/V1WriteBuilder))
* `SupportsTruncate` ([Spark SQL]({{ book.spark_sql }}/connector/SupportsTruncate))

## Creating Instance

`WriteIntoDeltaBuilder` takes the following to be created:

* <span id="log"> [DeltaLog](DeltaLog.md)
* <span id="writeOptions"> Write-Specific Options

`WriteIntoDeltaBuilder` is created when:

* `DeltaTableV2` is requested for a [WriteBuilder](DeltaTableV2.md#newWriteBuilder)

## <span id="buildForV1Write"> buildForV1Write

```scala
buildForV1Write(): InsertableRelation
```

`buildForV1Write` is part of the `V1WriteBuilder` ([Spark SQL]({{ book.spark_sql }}/connector/V1WriteBuilder#buildForV1Write)) abstraction.

`buildForV1Write` creates an `InsertableRelation` ([Spark SQL]({{ book.spark_sql }}/InsertableRelation)) that does the following when requested to `insert`:

1. Creates and executes a [WriteIntoDelta](commands/WriteIntoDelta.md) command
1. Re-cache all cached plans (by requesting the `CacheManager` to `recacheByPlan` for a `LogicalRelation` over the [BaseRelation](DeltaLog.md#createRelation) of the [DeltaLog](#log))
