# InMemoryLogReplay

`InMemoryLogReplay` is used at the very last phase of [state reconstruction](Snapshot.md#stateReconstruction) (of a [cached delta state](Snapshot.md#cachedState)).

`InMemoryLogReplay` [handles](#append) a single partition of the [state reconstruction](Snapshot.md#stateReconstruction) dataset (based on the [spark.databricks.delta.snapshotPartitions](DeltaSQLConf.md#DELTA_SNAPSHOT_PARTITIONS) configuration property).

## Creating Instance

`InMemoryLogReplay` takes the following to be created:

* <span id="minFileRetentionTimestamp"> `minFileRetentionTimestamp` ([Snapshot.minFileRetentionTimestamp](Snapshot.md#minFileRetentionTimestamp))

`InMemoryLogReplay` is created when:

* `Snapshot` is requested for [state reconstruction](Snapshot.md#stateReconstruction)

## Lifecycle

The lifecycle of `InMemoryLogReplay` is as follows:

1. [Created](#creating-instance) (with [Snapshot.minFileRetentionTimestamp](Snapshot.md#minFileRetentionTimestamp))

1. [Append](#append) all [SingleAction](SingleAction.md)s of a partition (based on the [spark.databricks.delta.snapshotPartitions](DeltaSQLConf.md#DELTA_SNAPSHOT_PARTITIONS) configuration property)

1. [Checkpoint](#checkpoint)

## <span id="append"> Appending Actions

```scala
append(
  version: Long,
  actions: Iterator[Action]): Unit
```

`append` sets the [currentVersion](#currentVersion) to the given `version`.

`append` adds the given [actions](Action.md) to their respective registries.

Action   | Registry
---------|----------
 [SetTransaction](SetTransaction.md) | [transactions](#transactions) by [appId](SetTransaction.md#appId)
 [Metadata](Metadata.md) | [currentMetaData](#currentMetaData)
 [Protocol](Protocol.md) | [currentProtocolVersion](#currentProtocolVersion)
 [AddFile](AddFile.md) | 1. [activeFiles](#activeFiles) by [path](FileAction.md#path) and with [dataChange](AddFile.md#dataChange) flag disabled
 &nbsp;                | 2. Removes the path from [tombstones](#tombstones) (so there's only one [FileAction](FileAction.md) for a path)
 [RemoveFile](RemoveFile.md) | 1. Removes the path from [activeFiles](#activeFiles) (so there's only one [FileAction](FileAction.md) for a path)
 &nbsp;                | 2. [tombstones](#tombstones) by [path](FileAction.md#path) and with [dataChange](AddFile.md#dataChange) flag disabled
 [CommitInfo](CommitInfo.md) | Ignored
 [AddCDCFile](AddCDCFile.md) | Ignored

`append` throws an `AssertionError` when the [currentVersion](#currentVersion) is `-1` or one before the given `version`:

```text
Attempted to replay version [version], but state is at [currentVersion]
```

## <span id="checkpoint"> Current State of Delta Table

```scala
checkpoint: Iterator[Action]
```

`checkpoint` returns an `Iterator` ([Scala]({{ scala.api }}/scala/collection/Iterator.html)) of [Action](Action.md)s in the following order:

* [currentProtocolVersion](#currentProtocolVersion) if defined (non-``null``)
* [currentMetaData](#currentMetaData) if defined (non-``null``)
* [SetTransaction](#transactions)s
* [AddFile](#activeFiles)s and [RemoveFile](#getTombstones)s sorted by [path](FileAction.md#path) (lexicographically)

### <span id="getTombstones"> getTombstones

```scala
getTombstones: Iterable[FileAction]
```

`getTombstones` uses the [tombstones](#tombstones) internal registry for [RemoveFile](RemoveFile.md)s with [deletionTimestamp](RemoveFile.md#deletionTimestamp) after (_greater than_) the [minFileRetentionTimestamp](#minFileRetentionTimestamp).
