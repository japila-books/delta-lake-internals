# LogStore

`LogStore` is an [abstraction](#contract) of [transaction log stores](#implementations) (to read and write physical log files and checkpoints).

`LogStore` is created using [LogStoreProvider](LogStoreProvider.md#createLogStore) based on [spark.delta.logStore.class](../configuration-properties/index.md#spark.delta.logStore.class) configuration property.

## Contract

### <span id="invalidateCache"> invalidateCache

```scala
invalidateCache(): Unit
```

Used when:

* `DelegatingLogStore` is requested to [invalidateCache](DelegatingLogStore.md#invalidateCache)

### <span id="isPartialWriteVisible"> isPartialWriteVisible

```scala
isPartialWriteVisible(
  path: Path): Boolean // (1)!
isPartialWriteVisible(
  path: Path,
  hadoopConf: Configuration): Boolean
```

1. deprecated

Whether a partial write is visible when writing to `path`

Default: `true`

Used when:

* `Checkpoints` is requested to [writeCheckpoint](../checkpoints/Checkpoints.md#writeCheckpoint)
* `OptimisticTransactionImpl` is requested to [isCommitLockEnabled](../OptimisticTransactionImpl.md#isCommitLockEnabled)
* `DelegatingLogStore` is requested to [isPartialWriteVisible](DelegatingLogStore.md#isPartialWriteVisible)

### <span id="listFrom"> listFrom

```scala
listFrom(
  path: Path): Iterator[FileStatus]
listFrom(
  path: String): Iterator[FileStatus]  
```

Used when:

* `Checkpoints` is requested to [findLastCompleteCheckpoint](../checkpoints/Checkpoints.md#findLastCompleteCheckpoint)
* `DeltaHistoryManager` is requested to [getEarliestDeltaFile](../DeltaHistoryManager.md#getEarliestDeltaFile), [getEarliestReproducibleCommit](../DeltaHistoryManager.md#getEarliestReproducibleCommit) and [getCommits](../DeltaHistoryManager.md#getCommits)
* `DeltaLog` is requested to [getChanges](../DeltaLog.md#getChanges)
* `MetadataCleanup` is requested to [listExpiredDeltaLogs](../MetadataCleanup.md#listExpiredDeltaLogs)
* `SnapshotManagement` is requested to [listFrom](../SnapshotManagement.md#listFrom)
* `DelegatingLogStore` is requested to [listFrom](DelegatingLogStore.md#listFrom)
* `DeltaFileOperations` utility is used to [listUsingLogStore](../DeltaFileOperations.md#listUsingLogStore)

### <span id="read"> read

```scala
read(
  path: Path): Seq[String]
read(
  path: String): Seq[String]
```

Used when:

* `Checkpoints` is requested to [loadMetadataFromFile](../checkpoints/Checkpoints.md#loadMetadataFromFile)
* `ReadChecksum` is requested to [readChecksum](../ReadChecksum.md#readChecksum)
* `DeltaLog` is requested to [getChanges](../DeltaLog.md#getChanges)
* `OptimisticTransactionImpl` is requested to [checkForConflicts](../OptimisticTransactionImpl.md#checkForConflicts)
* `DelegatingLogStore` is requested to [read](DelegatingLogStore.md#read)
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

* `Checkpoints` is requested to [checkpoint](../checkpoints/Checkpoints.md#checkpoint)
* `OptimisticTransactionImpl` is requested to [doCommit](../OptimisticTransactionImpl.md#doCommit)
* `DeltaCommand` is requested to [commitLarge](../commands/DeltaCommand.md#commitLarge)
* `GenerateSymlinkManifestImpl` is requested to [writeManifestFiles](../GenerateSymlinkManifest.md#writeManifestFiles)
* `DelegatingLogStore` is requested to [write](DelegatingLogStore.md#write)

## Implementations

* [DelegatingLogStore](DelegatingLogStore.md)
* [HadoopFileSystemLogStore](HadoopFileSystemLogStore.md)
* [LogStoreAdaptor](LogStoreAdaptor.md)

## <span id="apply"> Creating LogStore

```scala
apply(
  sc: SparkContext): LogStore
apply(
  sparkConf: SparkConf,
  hadoopConf: Configuration): LogStore
```

`apply` [creates a LogStore](LogStoreProvider.md#createLogStore).

`apply` is used when:

* `GenerateSymlinkManifestImpl` is requested to [writeManifestFiles](../GenerateSymlinkManifest.md#writeManifestFiles) and [writeSingleManifestFile](../GenerateSymlinkManifest.md#writeSingleManifestFile)
* `DeltaHistoryManager` is requested to [getHistory](../DeltaHistoryManager.md#getHistory) and [getActiveCommitAtTime](../DeltaHistoryManager.md#getActiveCommitAtTime)
* `DeltaFileOperations` is requested to [recursiveListDirs](../DeltaFileOperations.md#recursiveListDirs), [localListDirs](../DeltaFileOperations.md#localListDirs), and [localListFrom](../DeltaFileOperations.md#localListFrom)

## <span id="createLogStoreWithClassName"> createLogStoreWithClassName

```scala
createLogStoreWithClassName(
  className: String,
  sparkConf: SparkConf,
  hadoopConf: Configuration): LogStore
```

`createLogStoreWithClassName` branches off based on the given `className`.

`createLogStoreWithClassName` creates a [DelegatingLogStore](DelegatingLogStore.md) when the `className` is the fully-qualified class name of `DelegatingLogStore`.

Otherwise, `createLogStoreWithClassName` loads the class and braches off based on the class type.

For [io.delta.storage.LogStore](../LogStore.md), `createLogStoreWithClassName` creates an instance thereof (with the given `Configuration`) and wraps it up in a [LogStoreAdaptor](LogStoreAdaptor.md).

For all other cases, `createLogStoreWithClassName` creates an instance thereof (with the given `SparkConf` and `Configuration`).

`createLogStoreWithClassName` is used when:

* `DelegatingLogStore` is requested to [createLogStore](DelegatingLogStore.md#createLogStore)
* `LogStoreProvider` is requested to [createLogStore](LogStoreProvider.md#createLogStore)

## <span id="logStoreSchemeConfKey"> logStoreSchemeConfKey

```scala
logStoreSchemeConfKey(
  scheme: String): String
```

`logStoreSchemeConfKey` simply returns the following text for the given `scheme`:

```text
spark.delta.logStore.[scheme].impl
```

`logStoreSchemeConfKey` is used when:

* `DelegatingLogStore` is requested to [schemeBasedLogStore](DelegatingLogStore.md#schemeBasedLogStore)
