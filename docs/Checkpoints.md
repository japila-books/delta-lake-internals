# Checkpoints

`Checkpoints` is an abstraction of [DeltaLogs](#implementations) that can [checkpoint](#checkpoint) the current state of a [delta table](#self).

<span id="self">
`Checkpoints` requires to be used with [DeltaLog](DeltaLog.md) (or subtypes) only.

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

Used when:

* `Checkpoints` is requested to [checkpoint](#checkpoint)

### <span id="logPath"> logPath

```scala
logPath: Path
```

Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) to the log directory of the [delta table](#self)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

[Metadata](Metadata.md) of the [delta table](#self)

### <span id="snapshot"> snapshot

```scala
snapshot: Snapshot
```

[Snapshot](Snapshot.md) of the [delta table](#self)

### <span id="store"> store

```scala
store: LogStore
```

[LogStore](LogStore.md)

## Implementations

* [DeltaLog](DeltaLog.md)

## <span id="LAST_CHECKPOINT"><span id="_last_checkpoint"> _last_checkpoint Metadata File

`Checkpoints` uses **_last_checkpoint** metadata file (under the [log path](#logPath)) for the following:

* [Writing checkpoint metadata out](#checkpoint)

* [Loading checkpoint metadata in](#loadMetadataFromFile)

## <span id="checkpoint"> Checkpointing

```scala
checkpoint(): Unit
checkpoint(
  snapshotToCheckpoint: Snapshot): CheckpointMetaData
```

`checkpoint` [writes a checkpoint](#writeCheckpoint) of the current state of the delta table ([Snapshot](SnapshotManagement.md#snapshot)). That produces a checkpoint metadata with the version, the number of actions and possibly parts (for multi-part checkpoints).

`checkpoint` requests the [LogStore](DeltaLog.md#store) to [overwrite](LogStore.md#write) the [_last_checkpoint](#LAST_CHECKPOINT) file with the JSON-encoded checkpoint metadata.

In the end, `checkpoint` [cleans up the expired logs](MetadataCleanup.md#doLogCleanup) (if enabled).

`checkpoint` is used when:

* `OptimisticTransactionImpl` is requested to [postCommit](OptimisticTransactionImpl.md#postCommit) (based on [checkpoint interval](DeltaConfigs.md#CHECKPOINT_INTERVAL) table property)
* [ConvertToDelta](commands/convert/index.md) command is executed (that in the end requests `DeltaCommand` to [updateAndCheckpoint](commands/DeltaCommand.md#updateAndCheckpoint))

### <span id="writeCheckpoint"> Writing Out State Checkpoint

```scala
writeCheckpoint(
  spark: SparkSession,
  deltaLog: DeltaLog,
  snapshot: Snapshot): CheckpointMetaData
```

`writeCheckpoint`...FIXME

## <span id="lastCheckpoint"> Loading Latest Checkpoint Metadata

```scala
lastCheckpoint: Option[CheckpointMetaData]
```

`lastCheckpoint` [loadMetadataFromFile](#loadMetadataFromFile) (allowing for 3 retries).

`lastCheckpoint` is used when:

* `SnapshotManagement` is requested to [load the latest snapshot](SnapshotManagement.md#getSnapshotAtInit)
* `MetadataCleanup` is requested to [listExpiredDeltaLogs](MetadataCleanup.md#listExpiredDeltaLogs)

### <span id="loadMetadataFromFile"> loadMetadataFromFile

```scala
loadMetadataFromFile(
  tries: Int): Option[CheckpointMetaData]
```

`loadMetadataFromFile` loads the [_last_checkpoint](LAST_CHECKPOINT) file (in JSON format) and converts it to `CheckpointMetaData` (with a version, size and parts).

`loadMetadataFromFile` uses the [LogStore](DeltaLog.md#store) to [read](#read) the [_last_checkpoint](LAST_CHECKPOINT) file.

In case the [_last_checkpoint](LAST_CHECKPOINT) file is corrupted, `loadMetadataFromFile`...FIXME
