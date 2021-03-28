# FileAction

`FileAction` is an [extension](#contract) of the [Action](Action.md) abstraction for [actions](#implementations) that can add or remove files.

## Contract

### <span id="path"> Path

```scala
path: String
```

### <span id="dataChange"> dataChange

```scala
dataChange: Boolean
```

Controls the [transaction isolation level](IsolationLevel.md) for [committing a transaction](OptimisticTransactionImpl.md#commit)

Isolation Level | Description
----------------|---------
 [SnapshotIsolation](IsolationLevel.md#SnapshotIsolation) | No data changes (`dataChange` is `false` for all `FileAction`s to be committed)
 [Serializable](IsolationLevel.md#Serializable) | &nbsp;

There can be no [RemoveFile](RemoveFile.md)s with `dataChange` enabled for [appendOnly](DeltaConfigs.md#appendOnly) unmodifiable tables (or an [UnsupportedOperationException is thrown](DeltaLog.md#assertRemovable)).

dataChange Value | When
-----------------|---------
 `false` | `InMemoryLogReplay` is requested to [replay a version](InMemoryLogReplay.md#append)
 `true` | [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) is executed (and requested to [create an AddFile](commands/ConvertToDeltaCommand.md#createAddFile) with the flag turned on)
 Opposite of [dataChange](options.md#dataChange) option | `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write) (with [dataChange](options.md#dataChange) option turned off for rearrange-only writes)

`dataChange` is used when:

* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit) (and determines the isolation level), [prepareCommit](OptimisticTransactionImpl.md#prepareCommit), [attempt a commit](OptimisticTransactionImpl.md#doCommit) (for `bytesNew` statistics)
* `DeltaSource` is requested to [getChanges](DeltaSource.md#getChanges) (and [verifyStreamHygieneAndFilterAddFiles](DeltaSource.md#verifyStreamHygieneAndFilterAddFiles))

## Implementations

* [AddCDCFile](AddCDCFile.md)
* [AddFile](AddFile.md)
* [RemoveFile](RemoveFile.md)

??? note "Sealed Trait"
    `FileAction` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
