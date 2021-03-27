# IsolationLevel

`IsolationLevel` is an [abstraction](#contract) of [consistency guarantees](#implementations) to be provided when `OptimisticTransaction` is [committed](OptimisticTransaction.md#commit).

## Implementations

!!! note "Sealed Trait"
    `IsolationLevel` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

### <span id="Serializable"> Serializable

### <span id="SnapshotIsolation"> SnapshotIsolation

### <span id="WriteSerializable"><span id="DEFAULT"> WriteSerializable

The default `IsolationLevel`

## <span id="validTableIsolationLevels"> Valid Table Isolation Levels

The following are the valid isolation levels that can be specified as the table isolation level:

* [Serializable](#Serializable)
* [WriteSerializable](#WriteSerializable)

## <span id="allLevelsInDescOrder"> Strictness Ordering

The following are all the isolation levels in descending order of guarantees provided:

1. [Serializable](#Serializable) is the most strict level
1. [WriteSerializable](#WriteSerializable)
1. [SnapshotIsolation](#SnapshotIsolation) is the least strict one
