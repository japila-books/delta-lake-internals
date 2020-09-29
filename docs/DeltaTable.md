# DeltaTable

**DeltaTable** is the [management interface](#operators) of a Delta table.

DeltaTable instances are created using [utilities](#utilities) (e.g. [DeltaTable.forName](#forName), [DeltaTable.convertToDelta](#convertToDelta)).

## <span id="utilities"> Utilities (Static Methods)

### <span id="convertToDelta"> convertToDelta

```scala
convertToDelta(
  spark: SparkSession,
  identifier: String): DeltaTable
convertToDelta(
  spark: SparkSession,
  identifier: String,
  partitionSchema: String): DeltaTable
convertToDelta(
  spark: SparkSession,
  identifier: String,
  partitionSchema: StructType): DeltaTable
```

`convertToDelta` converts a parquet table to delta format (and makes the table available in Delta Lake).

!!! note
    Refer to [Demo: Converting Parquet Dataset Into Delta Format](demo/Converting-Parquet-Dataset-Into-Delta-Format.md) for a demo of `DeltaTable.convertToDelta`.

Internally, `convertToDelta` requests the `SparkSession` for the SQL parser (`ParserInterface`) that is in turn requested to parse the given table identifier (to get a `TableIdentifier`).

!!! tip
    Read up on [ParserInterface](https://jaceklaskowski.github.io/mastering-spark-sql-book/sql/ParserInterface/) in [The Internals of Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book) online book.

In the end, `convertToDelta` uses the `DeltaConvert` utility to [convert the parquet table to delta format](DeltaConvert.md#executeConvert) and [creates a DeltaTable](#forPath).

### <span id="forName"> forName

```scala
forName(
  sparkSession: SparkSession,
  tableName: String): DeltaTable
forName(
  tableOrViewName: String): DeltaTable
```

`forName` uses `ParserInterface` (of the given `SparkSession`) to parse the given table name.

`forName` [checks whether the given table name is of a Delta table](DeltaTableUtils.md#isDeltaTable) and, if so, creates a DeltaTable with the following:

* Dataset that represents loading data from the specified table name (using `SparkSession.table` operator)
* [DeltaLog](DeltaLog.md#forTable) of the specified table

`forName` throws an `AnalysisException` when the given table name is for non-Delta table:

```text
[deltaTableIdentifier] is not a Delta table.
```

`forName` is used internally when `DeltaConvert` utility is used to [executeConvert](DeltaConvert.md#executeConvert).

### <span id="forPath"> forPath

```scala
forPath(
  sparkSession: SparkSession,
  path: String): DeltaTable
forPath(
  path: String): DeltaTable
```

`forPath` creates a DeltaTable instance for data in the given directory (`path`) when the given [directory is part of a delta table](DeltaTableUtils.md#isDeltaTable) already (as the root or a child directory).

```text
assert(spark.isInstanceOf[org.apache.spark.sql.SparkSession])

val tableId = "/tmp/delta-table/users"

import io.delta.tables.DeltaTable
assert(DeltaTable.isDeltaTable(tableId), s"$tableId should be a Delta table")

val dt = DeltaTable.forPath("delta-table")
```

`forPath` throws an `AnalysisException` when the given `path` does not belong to a delta table:

```text
[deltaTableIdentifier] is not a Delta table.
```

Internally, forPath creates a new `DeltaTable` with the following:

* `Dataset` that represents loading data from the specified `path` using [delta](DeltaDataSource.md#delta-format) data source
* [DeltaLog](DeltaLog.md) for the [(transaction log in) the specified path](DeltaLog.md#forTable)

`forPath` is used internally in [DeltaTable.convertToDelta](#convertToDelta) (via [DeltaConvert](DeltaConvert.md) utility).

### <span id="isDeltaTable"> isDeltaTable

```scala
isDeltaTable(
  sparkSession: SparkSession,
  identifier: String): Boolean
isDeltaTable(
  identifier: String): Boolean
```

`isDeltaTable` checks whether the provided `identifier` string is a file path that points to the root of a Delta table or one of the subdirectories.

Internally, `isDeltaTable` simply relays to [DeltaTableUtils.isDeltaTable](DeltaTableUtils.md#isDeltaTable) utility.

## Creating Instance

`DeltaTable` takes the following to be created:

* <span id="df"> Table Data (`Dataset[Row]`)
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)

`DeltaTable` is created using [DeltaTable.forPath](#forPath) or [DeltaTable.forName](#forName) utilities.

## Operators

### <span id="alias"> alias

```scala
alias(
  alias: String): DeltaTable
```

Applies an alias to the DeltaTable (equivalent to [as](#as))

### <span id="as"> as

```scala
as(
  alias: String): DeltaTable
```

Applies an alias to the DeltaTable

### <span id="delete"> delete

```scala
delete(): Unit
delete(
  condition: Column): Unit
delete(
  condition: String): Unit
```

Deletes data from the DeltaTable that matches the given `condition`.

### <span id="generate"> generate

```scala
generate(
  mode: String): Unit
```

Generates a manifest for the delta table

`generate` [executeGenerate](DeltaTableOperations.md#executeGenerate) with the table ID of the format `++delta.`path`++` (where the path is the [data directory](DeltaLog.md#dataPath) of the [DeltaLog](#deltaLog)) and the given mode.

### <span id="history"> history

```scala
history(): DataFrame
history(
  limit: Int): DataFrame
```

Gets available commits (_history_) of the DeltaTable

### <span id="merge"> merge

```scala
merge(
  source: DataFrame,
  condition: Column): DeltaMergeBuilder
merge(
  source: DataFrame,
  condition: String): DeltaMergeBuilder
```

Creates a [DeltaMergeBuilder](commands/DeltaMergeBuilder.md)

### <span id="toDF"> toDF

```scala
toDF: Dataset[Row]
```

Returns the [DataFrame](#df) representation of the DeltaTable

### <span id="update"> update

```scala
update(
  condition: Column,
  set: Map[String, Column]): Unit
update(
  set: Map[String, Column]): Unit
```

Updates data in the DeltaTable on the rows that match the given `condition` based on the rules defined by `set`

### <span id="updateExpr"> updateExpr

```scala
updateExpr(
  set: Map[String, String]): Unit
updateExpr(
  condition: String,
  set: Map[String, String]): Unit
```

Updates data in the DeltaTable on the rows that match the given `condition` based on the rules defined by `set`

### <span id="vacuum"> vacuum

```scala
vacuum(): DataFrame
vacuum(
  retentionHours: Double): DataFrame
```

Deletes files and directories (recursively) in the DeltaTable that are not needed by the table (and maintains older versions up to the given retention threshold).

`vacuum` [executes vacuum command](DeltaTableOperations.md#executeVacuum).

## Demo

```text
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

val path = "/tmp/delta/t1"

// random data to create a delta table from scratch
val data = spark.range(5)
data.write.format("delta").save(path)

import io.delta.tables.DeltaTable
val dt = DeltaTable.forPath(spark, path)

val history = dt.history.select('version, 'timestamp, 'operation, 'operationParameters, 'isBlindAppend)
scala> history.show(truncate = false)
+-------+-------------------+---------+------------------------------------------+-------------+
|version|timestamp          |operation|operationParameters                       |isBlindAppend|
+-------+-------------------+---------+------------------------------------------+-------------+
|0      |2019-12-23 22:24:40|WRITE    |[mode -> ErrorIfExists, partitionBy -> []]|true         |
+-------+-------------------+---------+------------------------------------------+-------------+
```
