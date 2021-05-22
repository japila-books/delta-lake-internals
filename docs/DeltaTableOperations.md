# DeltaTableOperations &mdash; Delta DML Operations

`DeltaTableOperations` is an abstraction of [management services](#implementations) for executing [delete](#executeDelete), [generate](#executeGenerate), [history](#executeHistory), [update](#executeUpdate), and [vacuum](#executeVacuum) operations (_commands_).

<span id="self">
`DeltaTableOperations` is assumed to be associated with a [DeltaTable](DeltaTable.md).

Method | Command | DeltaTable Operator
---------|----------|---------
 <span id="executeDelete"> executeDelete | [DeltaDelete](commands/delete/DeltaDelete.md) | [DeltaTable.delete](DeltaTable.md#delete)
 <span id="executeGenerate"> executeGenerate | [DeltaGenerateCommand](commands/generate/DeltaGenerateCommand.md) | [DeltaTable.generate](DeltaTable.md#generate)
 <span id="executeHistory"> executeHistory | [DeltaHistoryManager.getHistory](DeltaHistoryManager.md#getHistory) | [DeltaTable.history](DeltaTable.md#history)
 <span id="executeUpdate"> executeUpdate | `UpdateTable` ([Spark SQL]({{ book.spark_sql }}/logical-operators/UpdateTable)) | [DeltaTable.update](DeltaTable.md#update) and [DeltaTable.updateExpr](DeltaTable.md#updateExpr)
 <span id="executeVacuum"> executeVacuum | [VacuumCommand.gc](commands/vacuum/VacuumCommand.md#gc) | [DeltaTable.vacuum](DeltaTable.md#vacuum)

## Implementations

* [DeltaTable](DeltaTable.md)
