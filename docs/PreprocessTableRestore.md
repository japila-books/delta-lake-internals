# PreprocessTableRestore Logical Resolution

`PreprocessTableRestore` is a logical resolution rule (`Rule[LogicalPlan]`) to [resolve delta tables in RestoreTableStatements](#apply).

## Creating Instance

`PreprocessTableRestore` takes the following to be created:

* <span id="sparkSession"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))

`PreprocessTableRestore` is created when:

* `DeltaSparkSessionExtension` is requested to [register delta extensions](DeltaSparkSessionExtension.md#apply)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the `Rule` ([Spark SQL]({{ book.spark_sql }}/catalyst/Rule/#apply)) abstraction.

`apply` resolves [RestoreTableStatement](#RestoreTableStatement)s with `UnresolvedRelation`s of delta tables to `RestoreTableStatement`s with [DeltaTableV2](DeltaTableV2.md)s.

### <span id="RestoreTableStatement"> RestoreTableStatement

For a [RestoreTableStatement](commands/restore/RestoreTableStatement.md) with a `TimeTravel` on an `UnresolvedRelation`, `apply` tries to look up the relation in the `SessionCatalog` ([Spark SQL]({{ book.spark_sql }}/SessionCatalog)).

For a [delta table](DeltaTableUtils.md#isDeltaTable), `apply` requests the `SessionCatalog` for a table metadata and creates a [DeltaTableV2](DeltaTableV2.md) (with the location from the catalog).

For a [delta table](DeltaTableUtils.md#isDeltaTable) registered in a catalog, `apply` requests the `SessionCatalog` for the metadata and creates a [DeltaTableV2](DeltaTableV2.md) (with the location from the catalog).

For the table identifier that is a [valid path of a delta table](DeltaTableUtils.md#isValidPath), `apply` creates a [DeltaTableV2](DeltaTableV2.md) (with the location).

!!! note
    For all other cases, `apply` throws an exception.

In the end, `apply` creates a `DataSourceV2Relation` with the `DeltaTableV2` as a child of a new [RestoreTableStatement](commands/restore/RestoreTableStatement.md).
