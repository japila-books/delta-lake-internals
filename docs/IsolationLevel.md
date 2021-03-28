# IsolationLevel

`IsolationLevel` is an [abstraction](#contract) of [consistency guarantees](#implementations) to be provided when `OptimisticTransaction` is [committed](OptimisticTransaction.md#commit).

## Implementations

!!! note "Sealed Trait"
    `IsolationLevel` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

### <span id="Serializable"> Serializable

`Serializable` is the [most strict consistency guarantee](#allLevelsInDescOrder).

`Serializable` is the isolation level for [data-changing commit](OptimisticTransactionImpl.md#commit-isolationLevelToUse)s.

For `Serializable` commits, `OptimisticTransactionImpl` adds extra `addedFilesToCheckForConflicts` (`changedData` or `blindAppend` [AddFile](AddFile.md)s) when [checkForConflicts](OptimisticTransactionImpl.md#checkForConflicts).

`Serializable` is a valid isolation level as the [table isolation level](#validTableIsolationLevels).

For operations that do not modify data in a table, there is no difference between [Serializable](#Serializable) and [SnapshotIsolation](#SnapshotIsolation).

`Serializable` is used for [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) command.

### <span id="SnapshotIsolation"> SnapshotIsolation

`SnapshotIsolation` is the [least strict consistency guarantee](#allLevelsInDescOrder).

`SnapshotIsolation` is the isolation level for [commit](OptimisticTransactionImpl.md#commit-isolationLevelToUse)s with no [data changed](FileAction.md#dataChange).

For `SnapshotIsolation` commits, `OptimisticTransactionImpl` adds no extra `addedFilesToCheckForConflicts` when [checkForConflicts](OptimisticTransactionImpl.md#checkForConflicts).

For operations that do not modify data in a table, there is no difference between [Serializable](#Serializable) and [SnapshotIsolation](#SnapshotIsolation).

### <span id="WriteSerializable"><span id="DEFAULT"> WriteSerializable

The default `IsolationLevel`

`WriteSerializable` is a valid isolation level as the [table isolation level](#validTableIsolationLevels).

## <span id="validTableIsolationLevels"> Valid Table Isolation Levels

The following are the valid isolation levels that can be specified as the table isolation level:

* [Serializable](#Serializable)
* [WriteSerializable](#WriteSerializable)

## <span id="allLevelsInDescOrder"> Consistency Guarantee Strictness Ordering

The following are all the isolation levels in descending order of guarantees provided:

1. [Serializable](#Serializable) (the most strict level)
1. [WriteSerializable](#WriteSerializable)
1. [SnapshotIsolation](#SnapshotIsolation) (the least strict one)
