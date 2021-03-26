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

`dataChange` is used when:

* `InMemoryLogReplay` is requested to [append](InMemoryLogReplay.md#append)
* [ConvertToDeltaCommand](commands/ConvertToDeltaCommand.md) is executed (and requested to [createAddFile](commands/ConvertToDeltaCommand.md#createAddFile))
* `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write) (with [dataChange](options.md#dataChange) option turned off)
* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit) (and determines the isolation level), [prepareCommit](OptimisticTransactionImpl.md#prepareCommit), [attempt a commit](OptimisticTransactionImpl.md#doCommit) (for `bytesNew` statistics)
* `DeltaSource` is requested to [verifyStreamHygieneAndFilterAddFiles](DeltaSource.md#verifyStreamHygieneAndFilterAddFiles)

## Implementations

* [AddCDCFile](AddCDCFile.md)
* [AddFile](AddFile.md)
* [RemoveFile](RemoveFile.md)

??? note "Sealed Trait"
    `FileAction` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).
