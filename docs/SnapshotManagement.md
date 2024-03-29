# SnapshotManagement

`SnapshotManagement` is an extension for [DeltaLog](DeltaLog.md) to manage [Snapshot](#currentSnapshot)s.

## <span id="snapshot"> Current Snapshot { #currentSnapshot }

```scala
currentSnapshot: CapturedSnapshot
```

`SnapshotManagement` defines `currentSnapshot` registry with the recently-loaded [Snapshot](Snapshot.md) of the [delta table](DeltaLog.md).

`currentSnapshot` is the [latest Snapshot](#getSnapshotAtInit) initially and can be [updated](#update) on demand (when [installLogSegmentInternal](#installLogSegmentInternal) and [replaceSnapshot](#replaceSnapshot)).

`currentSnapshot`...FIXME

---

`currentSnapshot` is used when `SnapshotManagement` is requested for the following:

* [unsafeVolatileSnapshot](#unsafeVolatileSnapshot)
* [update](#update) ([tryUpdate](#tryUpdate), [updateInternal](#updateInternal), [installLogSegmentInternal](#installLogSegmentInternal), [replaceSnapshot](#replaceSnapshot))
* [updateAfterCommit](#updateAfterCommit)

### Loading Latest Snapshot at Initialization { #getSnapshotAtInit }

```scala
getSnapshotAtInit: CapturedSnapshot
```

`getSnapshotAtInit` [finds the LogSegment](#getLogSegmentFrom) of the delta table (using the [last checkpoint file](checkpoints/Checkpoints.md#readLastCheckpointFile) if available)

In the end, `getSnapshotAtInit` [createSnapshotAtInitInternal](#createSnapshotAtInitInternal).

### <span id="createSnapshotAtInitInternal"> createSnapshotAtInitInternal

```scala
createSnapshotAtInitInternal(
  initSegment: Option[LogSegment],
  lastCheckpointOpt: Option[CheckpointMetaData],
  timestamp: Long): CapturedSnapshot
```

`createSnapshotAtInitInternal`...FIXME

### Fetching Log Files for Version Checkpointed { #getLogSegmentFrom }

```scala
getLogSegmentFrom(
  startingCheckpoint: Option[LastCheckpointInfo]): Option[LogSegment]
```

`getLogSegmentFrom` [fetches log files for the version](#getLogSegmentForVersion) (based on the optional `CheckpointMetaData` as the starting checkpoint version to start listing log files from).

## Fetching Latest LogSegment for Version { #getLogSegmentForVersion }

```scala
getLogSegmentForVersion(
  versionToLoad: Option[Long] = None,
  oldCheckpointProviderOpt: Option[UninitializedCheckpointProvider] = None,
  lastCheckpointInfo: Option[LastCheckpointInfo] = None): Option[LogSegment]
getLogSegmentForVersion(
  versionToLoad: Option[Long],
  files: Option[Array[FileStatus]],
  validateLogSegmentWithoutCompactedDeltas: Boolean,
  oldCheckpointProviderOpt: Option[UninitializedCheckpointProvider],
  lastCheckpointInfo: Option[LastCheckpointInfo]): Option[LogSegment]
```

`getLogSegmentForVersion` [list all the files](#listFrom) (in a transaction log) from the given `startCheckpoint` (or defaults to `0`).

`getLogSegmentForVersion` filters out unnecessary files and leaves [checkpoint](#isCheckpointFile) and [delta](#isDeltaFile) files only.

`getLogSegmentForVersion` filters out checkpoint files of size `0`.

`getLogSegmentForVersion` takes all the files that are [older than](#getFileVersion) the requested `versionToLoad`.

`getLogSegmentForVersion` splits the files into [checkpoint](#isCheckpointFile) and [delta](#isDeltaFile) files.

`getLogSegmentForVersion` finds the latest checkpoint from the list.

In the end, `getLogSegmentForVersion` creates a [LogSegment](LogSegment.md) with the (checkpoint and delta) files.

---

`getLogSegmentForVersion` is used when:

* `SnapshotManagement` is requested to [getUpdatedLogSegment](#getUpdatedLogSegment), [getLogSegmentAfterCommit](#getLogSegmentAfterCommit), [getLogSegmentFrom](#getLogSegmentFrom), [getSnapshotAt](#getSnapshotAt), [updateInternal](#updateInternal)

### Listing Files from Version Upwards { #listFrom }

```scala
listFrom(
  startVersion: Long): Iterator[FileStatus]
```

`listFrom`...FIXME

### validateDeltaVersions { #validateDeltaVersions }

```scala
validateDeltaVersions(
  selectedDeltas: Array[FileStatus],
  checkpointVersion: Long,
  versionToLoad: Option[Long]): Unit
```

??? warning "Procedure"
    `validateDeltaVersions` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`validateDeltaVersions`...FIXME

## <span id="createSnapshot"> Creating Snapshot

```scala
createSnapshot(
  segment: LogSegment,
  minFileRetentionTimestamp: Long,
  timestamp: Long): Snapshot
```

`createSnapshot` [readChecksum](ReadChecksum.md#readChecksum) (for the version of the given [LogSegment](LogSegment.md)) and creates a [Snapshot](Snapshot.md).

`createSnapshot` is used when:

* `SnapshotManagement` is requested for [getSnapshotAtInit](#getSnapshotAtInit), [updateInternal](#updateInternal) and [getSnapshotAt](#getSnapshotAt)

## <span id="lastUpdateTimestamp"> Last Successful Update Timestamp

`SnapshotManagement` uses `lastUpdateTimestamp` internal registry for the timestamp of the last successful update.

## Updating Snapshot { #update }

```scala
update(
  stalenessAcceptable: Boolean = false,
  checkIfUpdatedSinceTs: Option[Long] = None): Snapshot
```

`update` determines whether to do update asynchronously or not based on the input `stalenessAcceptable` flag and [isSnapshotStale](#isSnapshotStale).

With `stalenessAcceptable` flag turned off (the default value) and the state snapshot is not [stale](#isSnapshotStale), `update` [updates](#updateInternal) (with `isAsync` flag turned off).

`update`...FIXME

### <span id="update-usage"> Usage

`update` is used when:

* `DeltaHistoryManager` is requested to [getHistory](DeltaHistoryManager.md#getHistory), [getActiveCommitAtTime](DeltaHistoryManager.md#getActiveCommitAtTime), [checkVersionExists](DeltaHistoryManager.md#checkVersionExists)
* `DeltaLog` is requested to [start a transaction](DeltaLog.md#startTransaction)
* `OptimisticTransactionImpl` is requested to [doCommit](OptimisticTransactionImpl.md#doCommit) and [getNextAttemptVersion](OptimisticTransactionImpl.md#getNextAttemptVersion)
* `DeltaTableV2` is requested for a [Snapshot](DeltaTableV2.md#snapshot)
* `TahoeLogFileIndex` is requested for a [Snapshot](TahoeLogFileIndex.md#getSnapshot)
* `DeltaSource` is requested for the [getStartingVersion](spark-connector/DeltaSource.md#getStartingVersion)
* In [Delta commands](commands/DeltaCommand.md)...

### <span id="isSnapshotStale"> isSnapshotStale

```scala
isSnapshotStale: Boolean
```

`isSnapshotStale` reads [spark.databricks.delta.stalenessLimit](configuration-properties/DeltaSQLConf.md#DELTA_ASYNC_UPDATE_STALENESS_TIME_LIMIT) configuration property.

`isSnapshotStale` is enabled (`true`) when any of the following holds:

1. [spark.databricks.delta.stalenessLimit](configuration-properties/DeltaSQLConf.md#DELTA_ASYNC_UPDATE_STALENESS_TIME_LIMIT) configuration property is `0` (the default)
1. Internal [lastUpdateTimestamp](#lastUpdateTimestamp) has never been updated (and is below `0`) or is at least [spark.databricks.delta.stalenessLimit](configuration-properties/DeltaSQLConf.md#DELTA_ASYNC_UPDATE_STALENESS_TIME_LIMIT) configuration property old

### tryUpdate { #tryUpdate }

```scala
tryUpdate(
  isAsync: Boolean = false): Snapshot
```

`tryUpdate`...FIXME

### updateInternal { #updateInternal }

```scala
updateInternal(
  isAsync: Boolean): Snapshot
```

`updateInternal` requests the [current Snapshot](#currentSnapshot) for the [LogSegment](Snapshot.md#logSegment) that is in turn requested for the [checkpointVersion](LogSegment.md#checkpointVersion) to [get the LogSegment](#getLogSegmentForVersion) for.

`updateInternal` [installLogSegmentInternal](#installLogSegmentInternal).

#### <span id="installLogSegmentInternal"> installLogSegmentInternal

```scala
installLogSegmentInternal(
  previousSnapshot: Snapshot,
  segmentOpt: Option[LogSegment],
  updateTimestamp: Long,
  isAsync: Boolean): Snapshot // (1)!
```

1. `isAsync` is not used

`installLogSegmentInternal` gives the [Snapshot](Snapshot.md) (possibly an [InitialSnapshot](InitialSnapshot.md)) of the delta table at the [logPath](DeltaLog.md#logPath).

---

`installLogSegmentInternal`...FIXME

With no [LogSegment](LogSegment.md) specified, `installLogSegmentInternal` prints out the following INFO message to the logs and [replaceSnapshot](#replaceSnapshot) with a new [InitialSnapshot](InitialSnapshot.md) (for the [logPath](DeltaLog.md#logPath)).

```text
No delta log found for the Delta table at [logPath]
```

### <span id="replaceSnapshot"> Replacing Snapshots

```scala
replaceSnapshot(
  newSnapshot: Snapshot): Unit
```

`replaceSnapshot` requests the [currentSnapshot](#currentSnapshot) to [uncache](StateCache.md#uncache) (and drop any cached data) and makes the given `newSnapshot` the [current one](#currentSnapshot).

## updateAfterCommit { #updateAfterCommit }

```scala
updateAfterCommit(
  committedVersion: Long,
  newChecksumOpt: Option[VersionChecksum],
  preCommitLogSegment: LogSegment): Snapshot
```

`updateAfterCommit`...FIXME

---

`updateAfterCommit` is used when:

* `OptimisticTransactionImpl` is requested to [attempt a commit](OptimisticTransactionImpl.md#doCommit)

### getLogSegmentAfterCommit { #getLogSegmentAfterCommit }

```scala
getLogSegmentAfterCommit(
  oldCheckpointProvider: UninitializedCheckpointProvider): LogSegment
```

`getLogSegmentAfterCommit`...FIXME

## getSnapshotAt { #getSnapshotAt }

```scala
getSnapshotAt(
  version: Long,
  lastCheckpointProvider: CheckpointProvider): Snapshot
```

`getSnapshotAt`...FIXME

---

`getSnapshotAt` is used when:

* [CheckpointHook](checkpoints/CheckpointHook.md) is executed

## getUpdatedLogSegment { #getUpdatedLogSegment }

```scala
getUpdatedLogSegment(
  oldLogSegment: LogSegment): (LogSegment, Seq[FileStatus])
```

`getUpdatedLogSegment`...FIXME

---

`getUpdatedLogSegment` is used when:

* `OptimisticTransactionImpl` is requested to [getConflictingVersions](OptimisticTransactionImpl.md#getConflictingVersions)

## Demo

```scala
import org.apache.spark.sql.delta.DeltaLog
val log = DeltaLog.forTable(spark, dataPath)

import org.apache.spark.sql.delta.SnapshotManagement
assert(log.isInstanceOf[SnapshotManagement], "DeltaLog is a SnapshotManagement")
```

```scala
val snapshot = log.update(stalenessAcceptable = false)
```

```text
scala> :type snapshot
org.apache.spark.sql.delta.Snapshot

assert(snapshot.version == 0)
```

## Logging

As an extension of [DeltaLog](DeltaLog.md), use [DeltaLog](DeltaLog.md#logging) logging to see what happens inside.
