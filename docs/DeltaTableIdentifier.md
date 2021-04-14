# DeltaTableIdentifier

`DeltaTableIdentifier` is an identifier of a delta table by [TableIdentifier](#table) or [directory](#path) depending whether it is a catalog table or not (and living non-cataloged).

## Creating Instance

`DeltaTableIdentifier` takes the following to be created:

* <span id="path"> Directory (default: undefined)
* <span id="table"> `TableIdentifier` (default: undefined)

## <span id="apply"> Creating DeltaTableIdentifier

```scala
apply(
  spark: SparkSession,
  identifier: TableIdentifier): Option[DeltaTableIdentifier]
```

`apply` creates a new [DeltaTableIdentifier](#creating-instance) for the given `TableIdentifier` if the specified table identifier represents a Delta table or `None`.

`apply` is used when:

* [VacuumTableCommand](commands/vacuum/VacuumTableCommand.md), [DeltaGenerateCommand](commands/DeltaGenerateCommand.md), [DescribeDeltaDetailCommand](commands/DescribeDeltaDetailCommand.md) and [DescribeDeltaHistoryCommand](commands/DescribeDeltaHistoryCommand.md) are executed

## <span id="getDeltaLog"> Creating DeltaLog

```scala
getDeltaLog(
  spark: SparkSession): DeltaLog
```

`getDeltaLog` creates a [DeltaLog](DeltaLog.md#forTable) (for the [location](#getPath)).

!!! note
    `getDeltaLog` does not seem to be used.

### <span id="getPath"> Location Path

```scala
getPath(
  spark: SparkSession): Path
```

`getPath` creates a Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) for the [path](#path) if defined or requests `SessionCatalog` ([Spark SQL]({{ book.spark_sql }}/SessionCatalog)) for the table metadata and uses the `locationUri`.
