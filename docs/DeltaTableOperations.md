# DeltaTableOperations &mdash; Delta DML Operations

`DeltaTableOperations` is an abstraction of [management services](#implementations) for [DeltaTable commands](#delta-commands).

## Implementations

* [DeltaTable](DeltaTable.md)

## <span id="self"> DeltaTable

`DeltaTableOperations` uses Scala's **self-type** feature which forces it to be mixed into [DeltaTable](DeltaTable.md) or its subtypes.

## DeltaTable Commands

### <span id="executeDelete"> executeDelete

```scala
executeDelete(
  condition: Option[Expression]): Unit
```

`executeDelete` creates a `DeleteFromTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/DeleteFromTable)) logical command (for the analyzed query plan of the [DataFrame](DeltaTable.md#toDF) of the [DeltaTable](#self) and the given `condition`).

`executeDelete` creates a `DataFrame` for the `DeleteFromTable`.

!!! note "DeleteFromTable and DeltaDelete"
    `DeleteFromTable` is resolved to [DeltaDelete](commands/delete/DeltaDelete.md) logical command.

`executeDelete` is used when:

* `DeltaTable` is requested to [delete](DeltaTable.md#delete)

### <span id="executeGenerate"> executeGenerate

```scala
executeGenerate(
  tblIdentifier: String, mode: String): Unit
```

`executeGenerate` creates a `DataFrame` for a [DeltaGenerateCommand](commands/generate/DeltaGenerateCommand.md).

`executeGenerate` is used when:

* `DeltaTable` is requested to [generate](DeltaTable.md#generate)

### <span id="executeHistory"> executeHistory

```scala
executeHistory(
  deltaLog: DeltaLog,
  limit: Option[Int] = None,
  tableId: Option[TableIdentifier] = None): DataFrame
```

`executeHistory` requests the given [DeltaLog](DeltaLog.md) for the [DeltaHistoryManager](DeltaLog.md#history) for the [history](DeltaHistoryManager.md#getHistory).

`executeHistory` is used when:

* `DeltaTable` is requested to [history](DeltaTable.md#history)

### <span id="executeRestore"> executeRestore

```scala
executeRestore(
  table: DeltaTableV2,
  versionAsOf: Option[Long],
  timestampAsOf: Option[String]): DataFrame
```

`executeRestore` creates a [RestoreTableStatement](commands/restore/RestoreTableStatement.md) for a new `DataSourceV2Relation` ([Spark SQL]({{ book.spark_sql }}/logical-operators/DataSourceV2Relation)) (for the given [DeltaTableV2](DeltaTableV2.md) and the given `versionAsOf` and `timestampAsOf` time travel metadata).

`executeRestore` creates a `DataFrame` for the `DeleteFromTable`.

`executeRestore` is used when:

* `DeltaTable` is requested to [restoreToVersion](DeltaTable.md#restoreToVersion) and [restoreToTimestamp](DeltaTable.md#restoreToTimestamp)

### <span id="executeUpdate"> executeUpdate

```scala
executeUpdate(
  set: Map[String, Column],
  condition: Option[Column]): Unit
```

`executeUpdate` creates a `UpdateTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/UpdateTable)) logical command (for the analyzed query plan of the [DataFrame](DeltaTable.md#toDF) of the [DeltaTable](#self) and the given `condition`).

`executeDelete` creates a `DataFrame` for the `UpdateTable`.

!!! note "UpdateTable and DeltaUpdateTable"
    `UpdateTable` is resolved to [DeltaUpdateTable](commands/update/DeltaUpdateTable.md) logical command.

`executeUpdate` is used when:

* `DeltaTable` is requested to [update](DeltaTable.md#update) and [updateExpr](DeltaTable.md#updateExpr)

### <span id="executeVacuum"> executeVacuum

```scala
executeVacuum(
  deltaLog: DeltaLog,
  retentionHours: Option[Double],
  tableId: Option[TableIdentifier] = None): DataFrame
```

`executeVacuum` [runs garbage collection](commands/vacuum/VacuumCommand.md#gc) of the given [DeltaLog](DeltaLog.md).

`executeVacuum` is used when:

* `DeltaTable` is requested to [vacuum](DeltaTable.md#vacuum)
