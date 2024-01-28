# Checkpoints

`Checkpoints` is an abstraction of [DeltaLogs](#implementations) that can [checkpoint](#checkpoint) the current state of a [delta table](#self).

<span id="self">
`Checkpoints` requires to be used with [DeltaLog](../DeltaLog.md) (or subtypes) only.

## Contract

### <span id="dataPath"> dataPath

```scala
dataPath: Path
```

Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) to the data directory of the [delta table](#self)

### <span id="doLogCleanup"> doLogCleanup

```scala
doLogCleanup(): Unit
```

Performs log cleanup (to remove stale log files)

See:

* [DeltaLog](../DeltaLog.md#doLogCleanup)

Used when:

* `Checkpoints` is requested to [checkpointAndCleanUpDeltaLog](#checkpointAndCleanUpDeltaLog)

### <span id="logPath"> logPath

```scala
logPath: Path
```

Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) to the log directory of the [delta table](#self)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

[Metadata](../Metadata.md) of the [delta table](#self)

### <span id="snapshot"> snapshot

```scala
snapshot: Snapshot
```

[Snapshot](../Snapshot.md) of the [delta table](#self)

### <span id="store"> store

```scala
store: LogStore
```

[LogStore](../storage/LogStore.md)

## Implementations

* [DeltaLog](../DeltaLog.md)

## <span id="_last_checkpoint"> _last_checkpoint Metadata File { #LAST_CHECKPOINT }

`Checkpoints` uses **_last_checkpoint** metadata file (under the [log path](#logPath)) for the following:

* [Writing checkpoint metadata out](#checkpoint)

* [Loading checkpoint metadata in](#loadMetadataFromFile)

## <span id="checkpoint"> Checkpointing

```scala
checkpoint(): Unit
checkpoint(
  snapshotToCheckpoint: Snapshot): CheckpointMetaData
```

`checkpoint` [writes a checkpoint](#writeCheckpoint) of the current state of the delta table ([Snapshot](../SnapshotManagement.md#snapshot)). That produces a checkpoint metadata with the version, the number of actions and possibly parts (for multi-part checkpoints).

`checkpoint` requests the [LogStore](../DeltaLog.md#store) to [overwrite](../storage/LogStore.md#write) the [_last_checkpoint](#LAST_CHECKPOINT) file with the JSON-encoded checkpoint metadata.

In the end, `checkpoint` [cleans up the expired logs](../MetadataCleanup.md#doLogCleanup) (if enabled).

---

`checkpoint` is used when:

* `OptimisticTransactionImpl` is requested to [postCommit](../OptimisticTransactionImpl.md#postCommit) (based on [checkpoint interval](../table-properties/DeltaConfigs.md#CHECKPOINT_INTERVAL) table property)
* `DeltaCommand` is requested to [updateAndCheckpoint](../commands/DeltaCommand.md#updateAndCheckpoint)

### checkpointAndCleanUpDeltaLog { #checkpointAndCleanUpDeltaLog }

```scala
checkpointAndCleanUpDeltaLog(
  snapshotToCheckpoint: Snapshot): Unit
```

`checkpointAndCleanUpDeltaLog` does the following (in the order):

1. [writeCheckpointFiles](#writeCheckpointFiles)
1. [writeLastCheckpointFile](#writeLastCheckpointFile)
1. [doLogCleanup](#doLogCleanup)

### writeCheckpointFiles { #writeCheckpointFiles }

```scala
writeCheckpointFiles(
  snapshotToCheckpoint: Snapshot): CheckpointMetaData
```

`writeCheckpointFiles` [writes out a checkpoint](#writeCheckpoint) of the given [Snapshot](../Snapshot.md).

### Writing Out State Checkpoint { #writeCheckpoint }

```scala
writeCheckpoint(
  spark: SparkSession,
  deltaLog: DeltaLog,
  snapshot: Snapshot): CheckpointMetaData
```

`writeCheckpoint` writes out the contents of the given [Snapshot](../Snapshot.md) into one or more checkpoint files (based on [spark.databricks.delta.checkpoint.partSize](../configuration-properties/index.md#spark.databricks.delta.checkpoint.partSize) configuration property).

---

`writeCheckpoint` creates the following accumulators:

* `checkpointRowCount`
* `numOfFiles`

`writeCheckpoint` reads [spark.databricks.delta.checkpoint.partSize](../configuration-properties/index.md#DELTA_CHECKPOINT_PART_SIZE) configuration property to calculate the number and paths of this checkpoint (based on [numOfFiles](../Snapshot.md#numOfFiles) and [numOfRemoves](../Snapshot.md#numOfRemoves) of the given [Snapshot](../Snapshot.md)).

For multiple checkpoint parts (_paths_), `writeCheckpoint` [checkpointFileWithParts](#checkpointFileWithParts). Otherwise, `writeCheckpoint` [checkpointFileSingular](#checkpointFileSingular).

`writeCheckpoint` executes checkpointing (as a distributed computation using [stateDS](../Snapshot.md#stateDS) and as many tasks the number of checkpoint parts). `writeCheckpoint` uses a new execution ID with the name **Delta checkpoint**.

### writeLastCheckpointFile { #writeLastCheckpointFile }

```scala
writeLastCheckpointFile(
  deltaLog: DeltaLog,
  checkpointMetaData: CheckpointMetaData,
  addChecksum: Boolean): Unit
```

`writeLastCheckpointFile`...FIXME

## <span id="lastCheckpoint"> Loading Latest Checkpoint Metadata

```scala
lastCheckpoint: Option[CheckpointMetaData]
```

`lastCheckpoint` [loadMetadataFromFile](#loadMetadataFromFile) (allowing for 3 retries).

`lastCheckpoint` is used when:

* `SnapshotManagement` is requested to [load the latest snapshot](../SnapshotManagement.md#getSnapshotAtInit)
* `MetadataCleanup` is requested to [listExpiredDeltaLogs](../MetadataCleanup.md#listExpiredDeltaLogs)

### loadMetadataFromFile { #loadMetadataFromFile }

```scala
loadMetadataFromFile(
  tries: Int): Option[CheckpointMetaData]
```

`loadMetadataFromFile` loads the JSON-encoded [_last_checkpoint](#LAST_CHECKPOINT) file and converts it to `CheckpointMetaData` (with a version, size and parts).

`loadMetadataFromFile` uses the [LogStore](../DeltaLog.md#store) to [read](#read) the []`_last_checkpoint` file.

In case the `_last_checkpoint` file is corrupted, `loadMetadataFromFile`...FIXME
