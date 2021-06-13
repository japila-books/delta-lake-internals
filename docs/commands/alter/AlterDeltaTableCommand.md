# AlterDeltaTableCommand

`AlterDeltaTableCommand` is an [extension](#contract) of the [DeltaCommand](../DeltaCommand.md) abstraction for [Delta commands](#implementations) that alter a [DeltaTableV2](#table).

## Contract

### <span id="table"> table

```scala
table: DeltaTableV2
```

[DeltaTableV2](../../DeltaTableV2.md)

Used when:

* `AlterDeltaTableCommand` is requested to [startTransaction](#startTransaction)

## Implementations

* [AlterTableAddColumnsDeltaCommand](AlterTableAddColumnsDeltaCommand.md)
* [AlterTableAddConstraintDeltaCommand](AlterTableAddConstraintDeltaCommand.md)
* [AlterTableChangeColumnDeltaCommand](AlterTableChangeColumnDeltaCommand.md)
* [AlterTableDropConstraintDeltaCommand](AlterTableDropConstraintDeltaCommand.md)
* [AlterTableReplaceColumnsDeltaCommand](AlterTableReplaceColumnsDeltaCommand.md)
* [AlterTableSetLocationDeltaCommand](AlterTableSetLocationDeltaCommand.md)
* [AlterTableSetPropertiesDeltaCommand](AlterTableSetPropertiesDeltaCommand.md)
* [AlterTableUnsetPropertiesDeltaCommand](AlterTableUnsetPropertiesDeltaCommand.md)

## <span id="startTransaction"> startTransaction

```scala
startTransaction(): OptimisticTransaction
```

`startTransaction` simply requests the [DeltaTableV2](#table) for the [DeltaLog](../../DeltaTableV2.md#deltaLog) that in turn is requested to [startTransaction](../../DeltaLog.md#startTransaction).
