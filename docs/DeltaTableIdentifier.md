# DeltaTableIdentifier

`DeltaTableIdentifier` is an identifier of a delta table by [TableIdentifier](#table) or [directory](#path) depending whether it is a catalog table or not (and living non-cataloged).

## Creating Instance

`DeltaTableIdentifier` takes the following to be created:

* <span id="path"> Path to a delta table (default: undefined)
* <span id="table"> `TableIdentifier` (default: undefined)

Either a [path](#path) or a [table identifier](#table) is required.

## <span id="apply"> Creating DeltaTableIdentifier

```scala
apply(
  spark: SparkSession,
  identifier: TableIdentifier): Option[DeltaTableIdentifier]
```

`apply` creates a new [DeltaTableIdentifier](#creating-instance) for the given `TableIdentifier`:

1. For a [path](#isDeltaPath) (to a delta table), `apply` creates a `DeltaTableIdentifier` with the [path](#path)
1. For a [delta table](DeltaTableUtils.md#isDeltaTable), `apply` creates a `DeltaTableIdentifier` with a [TableIdentifier](#table)
1. For all the other cases, `apply` returns `None`

## <span id="isDeltaPath"> isDeltaPath

```scala
isDeltaPath(
  spark: SparkSession,
  identifier: TableIdentifier): Boolean
```

`isDeltaPath` checks whether the input `TableIdentifier` represents an (absolute) path to a delta table.

`isDeltaPath` is positive (`true`) when all the following hold:

1. `spark.sql.runSQLOnFiles` ([Spark SQL]({{ book.spark_sql }}/configuration-properties#spark.sql.runSQLOnFiles)) configuration property is `true`
1. [DeltaSourceUtils.isDeltaTable(identifier.database)](DeltaSourceUtils.md#isDeltaTable)
1. The `TableIdentifier` is not a temporary view
1. The table in the database (as specified in the `TableIdentifier`) does not exist
1. The table part (of the `TableIdentifier`) is absolute (starts with `/`)

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
