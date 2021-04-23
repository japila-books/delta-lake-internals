# LogStore

`LogStore` is an [abstraction](#contract) of [transaction log stores](#implementations).

## Contract

### <span id="invalidateCache"> invalidateCache

```scala
invalidateCache(): Unit
```

### <span id="isPartialWriteVisible"> isPartialWriteVisible

```scala
isPartialWriteVisible(
  path: Path): Boolean
```

Default: `true`

Used when:

* `Checkpoints` utility is used to [writeCheckpoint](Checkpoints.md#writeCheckpoint)

### <span id="listFrom"> listFrom

```scala
listFrom(
  path: Path): Iterator[FileStatus]
listFrom(
  path: String): Iterator[FileStatus]  
```

Used when:

* `Checkpoints` is requested to [findLastCompleteCheckpoint](Checkpoints.md#findLastCompleteCheckpoint)
* `DeltaHistoryManager` is requested to [getEarliestDeltaFile](DeltaHistoryManager.md#getEarliestDeltaFile), [getEarliestReproducibleCommit](DeltaHistoryManager.md#getEarliestReproducibleCommit) and [getCommits](DeltaHistoryManager.md#getCommits)
* `DeltaLog` is requested to [getChanges](DeltaLog.md#getChanges)
* `MetadataCleanup` is requested to [listExpiredDeltaLogs](MetadataCleanup.md#listExpiredDeltaLogs)
* `SnapshotManagement` is requested to [listFrom](SnapshotManagement.md#listFrom)
* `DeltaFileOperations` utility is used to [listUsingLogStore](DeltaFileOperations.md#listUsingLogStore)

### <span id="read"> read

```scala
read(
  path: Path): Seq[String]
read(
  path: String): Seq[String]
```

Used when:

* `Checkpoints` is requested to [loadMetadataFromFile](Checkpoints.md#loadMetadataFromFile)
* `ReadChecksum` is requested to [readChecksum](ReadChecksum.md#readChecksum)
* `DeltaLog` is requested to [getChanges](DeltaLog.md#getChanges)
* `OptimisticTransactionImpl` is requested to [checkForConflicts](OptimisticTransactionImpl.md#checkForConflicts)
* `LogStore` is requested to [readAsIterator](#readAsIterator)

### <span id="write"> write

```scala
write(
  path: Path,
  actions: Iterator[String],
  overwrite: Boolean = false): Unit
write(
  path: String,
  actions: Iterator[String]): Unit
```

Used when:

* `Checkpoints` is requested to [checkpoint](Checkpoints.md#checkpoint)
* `OptimisticTransactionImpl` is requested to [doCommit](OptimisticTransactionImpl.md#doCommit)
* `DeltaCommand` is requested to [commitLarge](commands/DeltaCommand.md#commitLarge)
* `GenerateSymlinkManifestImpl` is requested to [writeManifestFiles](GenerateSymlinkManifest.md#writeManifestFiles)

## Implementations

* [HadoopFileSystemLogStore](HadoopFileSystemLogStore.md)
