# FileAction

`FileAction` is an [extension](#contract) of the [Action](Action.md) abstraction for [data file-related actions](#implementations).

## Contract

### <span id="dataChange"> dataChange

```scala
dataChange: Boolean
```

Controls the [transaction isolation level](IsolationLevel.md) for [committing a transaction](OptimisticTransactionImpl.md#commit)

Isolation Level | Description
----------------|---------
 [SnapshotIsolation](IsolationLevel.md#SnapshotIsolation) | No data changes (`dataChange` is `false` for all `FileAction`s to be committed)
 [Serializable](IsolationLevel.md#Serializable) | &nbsp;

There can be no [RemoveFile](RemoveFile.md)s with `dataChange` enabled for [appendOnly](table-properties/DeltaConfigs.md#appendOnly) unmodifiable tables (or an [UnsupportedOperationException is thrown](DeltaLog.md#assertRemovable)).

dataChange Value | When
-----------------|---------
 `false` | `InMemoryLogReplay` is requested to [replay a version](InMemoryLogReplay.md#append)
 `true` | [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed (and requested to [create an AddFile](commands/convert/ConvertToDeltaCommand.md#createAddFile) with the flag turned on)
 Opposite of [dataChange](spark-connector/options.md#dataChange) option | `WriteIntoDelta` is requested to [write](commands/WriteIntoDelta.md#write) (with [dataChange](spark-connector/options.md#dataChange) option turned off for rearrange-only writes)

`dataChange` is used when:

* `OptimisticTransactionImpl` is requested to [commit](OptimisticTransactionImpl.md#commit) (and determines the isolation level), [prepareCommit](OptimisticTransactionImpl.md#prepareCommit), [attempt a commit](OptimisticTransactionImpl.md#doCommit) (for `bytesNew` statistics)
* `DeltaSource` is requested to [getChanges](spark-connector/DeltaSource.md#getChanges) (and [verifyStreamHygieneAndFilterAddFiles](spark-connector/DeltaSource.md#verifyStreamHygieneAndFilterAddFiles))

### <span id="numLogicalRecords"> numLogicalRecords

```scala
numLogicalRecords: Option[Long]
```

Always `None`:

* [AddCDCFile](AddCDCFile.md#numLogicalRecords)

See:

* [AddFile](AddFile.md#numLogicalRecords)
* [RemoveFile](RemoveFile.md#numLogicalRecords)

Used when:

* `DeleteCommandMetrics` is requested to [getDeletedRowsFromAddFilesAndUpdateMetrics](commands/delete/DeleteCommandMetrics.md#getDeletedRowsFromAddFilesAndUpdateMetrics)
* `TouchedFileWithDV` is requested to `isFullyReplaced`
* `MergeIntoCommand` is requested to [writeInsertsOnlyWhenNoMatchedClauses](commands/merge/MergeIntoCommand.md#writeInsertsOnlyWhenNoMatchedClauses)
* `WriteIntoDelta` is requested to [registerReplaceWhereMetrics](commands/WriteIntoDelta.md#registerReplaceWhereMetrics)
* `TransactionalWrite` is requested to [writeFiles](TransactionalWrite.md#writeFiles)
* `OptimizeMetadataOnlyDeltaQuery` is requested to [extractGlobalCount](data-skipping/OptimizeMetadataOnlyDeltaQuery.md#extractGlobalCount)

### <span id="partitionValues"> Partition Values

```scala
partitionValues: Map[String, String]
```

Partition columns to their values of this logical file

!!! note
    `partitionValues` is not used.

### Path

```scala
path: String
```

### Tags

```scala
tags: Map[String, String]
```

Metadata about this logical file

Used to [get the value of a tag](#getTag)

## Implementations

??? note "Sealed Trait"
    `FileAction` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#sealed).

* [AddCDCFile](AddCDCFile.md)
* [AddFile](AddFile.md)
* [RemoveFile](RemoveFile.md)

## <span id="getTag"> Tag Value

```scala
getTag(tagName: String): Option[String]
```

`getTag` gets the value of the given tag (by `tagName`), if available.

---

`getTag` is used when:

* `AddFile` is requested for a [tag value](AddFile.md#tag)
