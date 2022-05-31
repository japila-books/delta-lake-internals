# DeltaTable

`DeltaTable` is the [management interface](#operators) of delta tables.

## io.delta.tables Package

`DeltaTable` belongs to `io.delta.tables` package.

```scala
import io.delta.tables.DeltaTable
```

## Creating Instance

`DeltaTable` takes the following to be created:

* <span id="_df"> Table Data (`Dataset[Row]`)
* <span id="table"> [DeltaTableV2](DeltaTableV2.md)

`DeltaTable` is created using [DeltaTable.forPath](#forPath) and [DeltaTable.forName](#forName) utilities (and indirectly using [create](#create), [createIfNotExists](#createIfNotExists), [createOrReplace](#createOrReplace) and [replace](#replace)).

## <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaTableV2.md#deltaLog) of the [DeltaTableV2](#table).

## <span id="utilities"> Utilities (Static Methods)

### <span id="columnBuilder"> columnBuilder

```scala
columnBuilder(
  colName: String): DeltaColumnBuilder
columnBuilder(
  spark: SparkSession,
  colName: String): DeltaColumnBuilder
```

Creates a [DeltaColumnBuilder](DeltaColumnBuilder.md)

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

`convertToDelta` [converts the parquet table to delta format](commands/convert/DeltaConvert.md#executeConvert)

!!! note
    Refer to [Demo: Converting Parquet Dataset Into Delta Format](demo/Converting-Parquet-Dataset-Into-Delta-Format.md) for a demo of `DeltaTable.convertToDelta`.

### <span id="create"> create

```scala
create(): DeltaTableBuilder
create(
  spark: SparkSession): DeltaTableBuilder
```

Creates a [DeltaTableBuilder](DeltaTableBuilder.md)

### <span id="createIfNotExists"> createIfNotExists

```scala
createIfNotExists(): DeltaTableBuilder
createIfNotExists(
  spark: SparkSession): DeltaTableBuilder
```

Creates a [DeltaTableBuilder](DeltaTableBuilder.md) (with `CreateTableOptions` and `ifNotExists` flag enabled)

### <span id="createOrReplace"> createOrReplace

```scala
createOrReplace(): DeltaTableBuilder
createOrReplace(
  spark: SparkSession): DeltaTableBuilder
```

Creates a [DeltaTableBuilder](DeltaTableBuilder.md) (with `ReplaceTableOptions` and `orCreate` flag enabled)

### <span id="forName"> forName

```scala
forName(
  sparkSession: SparkSession,
  tableName: String): DeltaTable
forName(
  tableOrViewName: String): DeltaTable
```

`forName` uses `ParserInterface` (of the given `SparkSession`) to parse the given table name.

`forName` [checks whether the given table name is of a Delta table](DeltaTableUtils.md#isDeltaTable) and, if so, creates a [DeltaTable](#creating-instance) with the following:

* `Dataset` that represents loading data from the specified table name (using `SparkSession.table` operator)
* [DeltaTableV2](DeltaTableV2.md)

`forName` throws an `AnalysisException` when the given table name is for non-Delta table:

```text
[deltaTableIdentifier] is not a Delta table.
```

### <span id="forPath"> forPath

```scala
forPath(
  sparkSession: SparkSession,
  path: String): DeltaTable
forPath(
  path: String): DeltaTable
```

`forPath` [checks whether the given table name is of a Delta table](DeltaTableUtils.md#isDeltaTable) and, if so, creates a [DeltaTable](#creating-instance) with the following:

* `Dataset` that represents loading data from the specified `path` using [delta](DeltaDataSource.md#delta-format) data source
* [DeltaTableV2](DeltaTableV2.md)

`forPath` throws an `AnalysisException` when the given `path` does not belong to a delta table:

```text
[deltaTableIdentifier] is not a Delta table.
```

### <span id="isDeltaTable"> isDeltaTable

```scala
isDeltaTable(
  sparkSession: SparkSession,
  identifier: String): Boolean
isDeltaTable(
  identifier: String): Boolean
```

`isDeltaTable`...FIXME

### <span id="replace"> replace

```scala
replace(): DeltaTableBuilder
replace(
  spark: SparkSession): DeltaTableBuilder
```

Creates a [DeltaTableBuilder](DeltaTableBuilder.md) (with `ReplaceTableOptions` and `orCreate` flag disabled)

## Operators

### <span id="alias"> alias

```scala
alias(
  alias: String): DeltaTable
```

Applies an alias to the `DeltaTable` (equivalent to [as](#as))

### <span id="as"> as

```scala
as(
  alias: String): DeltaTable
```

Applies an alias to the `DeltaTable`

### <span id="delete"> delete

```scala
delete(): Unit
delete(
  condition: Column): Unit
delete(
  condition: String): Unit
```

[Executes DeleteFromTable command](DeltaTableOperations.md#executeDelete)

### <span id="generate"> generate

```scala
generate(
  mode: String): Unit
```

[Executes the DeltaGenerateCommand](DeltaTableOperations.md#executeGenerate)

### <span id="history"> history

```scala
history(): DataFrame
history(
  limit: Int): DataFrame
```

[Requests the DeltaHistoryManager for history](DeltaTableOperations.md#executeHistory).

### <span id="merge"> merge

```scala
merge(
  source: DataFrame,
  condition: Column): DeltaMergeBuilder
merge(
  source: DataFrame,
  condition: String): DeltaMergeBuilder
```

Creates a [DeltaMergeBuilder](commands/merge/DeltaMergeBuilder.md)

### <span id="restoreToTimestamp"> restoreToTimestamp

```scala
restoreToTimestamp(
  timestamp: String): DataFrame
```

[Executes Restore](DeltaTableOperations.md#executeRestore)

### <span id="restoreToVersion"> restoreToVersion

```scala
restoreToVersion(
  version: Long): DataFrame
```

[Executes Restore](DeltaTableOperations.md#executeRestore)

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

[Executes UpdateTable command](DeltaTableOperations.md#executeUpdate)

### <span id="updateExpr"> updateExpr

```scala
updateExpr(
  set: Map[String, String]): Unit
updateExpr(
  condition: String,
  set: Map[String, String]): Unit
```

[Executes UpdateTable command](DeltaTableOperations.md#executeUpdate)

### <span id="upgradeTableProtocol"> upgradeTableProtocol

```scala
upgradeTableProtocol(
  readerVersion: Int,
  writerVersion: Int): Unit
```

Updates the protocol version of the table to leverage new features.

Upgrading the reader version will prevent all clients that have an older version of Delta Lake from accessing this table.

Upgrading the writer version will prevent older versions of Delta Lake to write to this table.

The reader or writer version cannot be downgraded.

Internally, `upgradeTableProtocol` creates a new [Protocol](Protocol.md) (with the given versions) and requests the [DeltaLog](#deltaLog) to [upgradeProtocol](DeltaLog.md#upgradeProtocol).

??? "[SC-44271][DELTA] Introduce default protocol version for Delta tables"
    `upgradeTableProtocol` was introduced in [[SC-44271][DELTA] Introduce default protocol version for Delta tables]({{ delta.commit }}/6500abbf9a2f52046cbd30daaa81ffdc00cbb26f) commit.

### <span id="vacuum"> vacuum

```scala
vacuum(): DataFrame
vacuum(
  retentionHours: Double): DataFrame
```

[Deletes files and directories](DeltaTableOperations.md#executeVacuum) (recursively) in the [DeltaTable](#deltaLog) that are not needed by the table (and maintains older versions up to the given retention threshold).
