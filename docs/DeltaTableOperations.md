# DeltaTableOperations &mdash; Delta DML Operations

`DeltaTableOperations` is an abstraction of [management services](#implementations) for executing [delete](#executeDelete), [generate](#executeGenerate), [history](#executeHistory), [update](#executeUpdate), and [vacuum](#executeVacuum) operations (_commands_).

<span id="self">
`DeltaTableOperations` is assumed to be associated with a [DeltaTable](DeltaTable.md).

## Implementations

* [DeltaTable](DeltaTable.md)

## <span id="executeDelete"> Executing DeleteFromTable Command

```scala
executeDelete(
  condition: Option[Expression]): Unit
```

`executeDelete` creates a `DataFrame` for a `DeleteFromTable` logical operator (from Spark SQL) with (the analyzed logical plan of the [DeltaTable](#self) and the given `condition`).

!!! note
    `DeleteFromTable` is a `Command` (Spark SQL) that represents `DELETE FROM` SQL statement for v2 tables. As a `Command` it is executed eagerly.

`executeDelete` is used for [DeltaTable.delete](DeltaTable.md#delete) operator.

## <span id="executeGenerate"> Executing DeltaGenerateCommand Command

```scala
executeGenerate(
  tblIdentifier: String,
  mode: String): Unit
```

`executeGenerate` requests the SQL parser (of the `SparkSession`) to parse the given table identifier, creates a [DeltaGenerateCommand](commands/DeltaGenerateCommand.md) and runs it.

`executeGenerate` is used for [DeltaTable.generate](DeltaTable.md#generate) operator.

## <span id="executeHistory"> Executing History Command

```scala
executeHistory(
  deltaLog: DeltaLog,
  limit: Option[Int]): DataFrame
```

`executeHistory` creates [DeltaHistoryManager](DeltaHistoryManager.md) (for the given [DeltaLog](DeltaLog.md)) and requests it for the number of [commits](DeltaHistoryManager.md#getHistory) to match the `limit`. In the end, `executeHistory` creates a `DataFrame` for the commits.

`executeHistory` is used for [DeltaTable.history](DeltaTable.md#history) operator.

## <span id="executeUpdate"> Executing UpdateTable Command

```scala
executeUpdate(
  set: Map[String, Column],
  condition: Option[Column]): Unit
```

`executeUpdate` creates a `DataFrame` for a `UpdateTable` logical operator (from Spark SQL) with (the analyzed logical plan of the [DeltaTable](#self) and the given `condition`).

!!! note
    `UpdateTable` is a `Command` (Spark SQL) that represents `UPDATE TABLE` SQL statement for v2 tables. As a `Command` it is executed eagerly.

`executeUpdate` is used for [DeltaTable.update](DeltaTable.md#update) and [DeltaTable.updateExpr](DeltaTable.md#updateExpr) operators.

## <span id="executeVacuum"> Executing VacuumCommand

```scala
executeVacuum(
  deltaLog: DeltaLog,
  retentionHours: Option[Double]): DataFrame
```

`executeVacuum` uses the `VacuumCommand` utility to [gc](commands/VacuumCommand.md#gc) (with the `dryRun` flag off and the given `retentionHours`).

In the end, `executeVacuum` returns an empty `DataFrame`.

!!! note
    `executeVacuum` returns an empty `DataFrame` not the one from [VacuumCommand.gc](commands/VacuumCommand.md#gc).

NOTE: `executeVacuum` is used exclusively in <<DeltaTable.md#vacuum, DeltaTable.vacuum>> operator.
