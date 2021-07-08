# SnapshotManagement

`SnapshotManagement` is an extension for [DeltaLog](DeltaLog.md) to manage [Snapshot](#currentSnapshot)s.

## Demo

```text
val name = "employees"
val dataPath = s"/tmp/delta/$name"
sql(s"DROP TABLE $name")
sql(s"""
    | CREATE TABLE $name (id bigint, name string, city string)
    | USING delta
    | OPTIONS (path='$dataPath')
    """.stripMargin)

import org.apache.spark.sql.delta.DeltaLog
val log = DeltaLog.forTable(spark, dataPath)

import org.apache.spark.sql.delta.SnapshotManagement
assert(log.isInstanceOf[SnapshotManagement], "DeltaLog is a SnapshotManagement")

val snapshot = log.update(stalenessAcceptable = false)
scala> :type snapshot
org.apache.spark.sql.delta.Snapshot

assert(snapshot.version == 0)
```

## <span id="currentSnapshot"> Current Snapshot

```scala
currentSnapshot: Snapshot
```

`currentSnapshot` is a registry with the current [Snapshot](Snapshot.md) of a Delta table.

When [DeltaLog](DeltaLog.md) is created, `currentSnapshot` is initialized as [getSnapshotAtInit](#getSnapshotAtInit) and changed every [update](#update).

`currentSnapshot`...FIXME

`currentSnapshot` is used when:

* `SnapshotManagement` is requested to...FIXME

## <span id="update"> Updating Current Snapshot

```scala
update(
  stalenessAcceptable: Boolean = false): Snapshot
```

`update`...FIXME

`update` is used when:

* `DeltaLog` is requested to [start a transaction](DeltaLog.md#startTransaction) and [withNewTransaction](DeltaLog.md#withNewTransaction)
* `OptimisticTransactionImpl` is requested to [doCommit](OptimisticTransactionImpl.md#doCommit) and [getNextAttemptVersion](OptimisticTransactionImpl.md#getNextAttemptVersion)
* `DeltaTableV2` is requested for a [Snapshot](DeltaTableV2.md#snapshot)
* `TahoeLogFileIndex` is requested for a [Snapshot](TahoeLogFileIndex.md#getSnapshot)
* `DeltaHistoryManager` is requested to [getHistory](DeltaHistoryManager.md#getHistory), [getActiveCommitAtTime](DeltaHistoryManager.md#getActiveCommitAtTime), [checkVersionExists](DeltaHistoryManager.md#checkVersionExists)
* In [Delta commands](commands/DeltaCommand.md)...

### <span id="tryUpdate"> tryUpdate

```scala
tryUpdate(
  isAsync: Boolean = false): Snapshot
```

`tryUpdate`...FIXME

`tryUpdate` is used when `SnapshotManagement` is requested to [update](#update).

### <span id="updateInternal"> updateInternal

```scala
updateInternal(
  isAsync: Boolean): Snapshot
```

`updateInternal`...FIXME

`updateInternal` is used when `SnapshotManagement` is requested to [update](#update) (and [tryUpdate](#tryUpdate)).

## <span id="getSnapshotAtInit"> Loading Latest Snapshot

```scala
getSnapshotAtInit: Snapshot
```

`getSnapshotAtInit` [getLogSegmentFrom](#getLogSegmentFrom) for the [last checkpoint](Checkpoints.md#lastCheckpoint).

`getSnapshotAtInit` prints out the following INFO message to the logs:

```text
Loading version [version][startCheckpoint]
```

`getSnapshotAtInit` [creates a Snapshot](#createSnapshot) for the log segment.

`getSnapshotAtInit` records the current time in [lastUpdateTimestamp](#lastUpdateTimestamp) registry.

`getSnapshotAtInit` prints out the following INFO message to the logs:

```text
Returning initial snapshot [snapshot]
```

`getSnapshotAtInit` is used when `SnapshotManagement` is created (and initializes the [currentSnapshot](#currentSnapshot) registry).

### <span id="getLogSegmentFrom"> getLogSegmentFrom

```scala
getLogSegmentFrom(
  startingCheckpoint: Option[CheckpointMetaData]): LogSegment
```

`getLogSegmentFrom` [getLogSegmentForVersion](#getLogSegmentForVersion) for the version of the given `CheckpointMetaData` as a start checkpoint version.

`getLogSegmentFrom` is used when:

* `SnapshotManagement` is requested for [getSnapshotAtInit](#getSnapshotAtInit)

## <span id="getLogSegmentForVersion"> Fetching Log Files to Recreate Version

```scala
getLogSegmentForVersion(
  startCheckpoint: Option[Long],
  versionToLoad: Option[Long] = None): LogSegment
```

`getLogSegmentForVersion` [list all the files](#listFrom) (in a transaction log) from the given `startCheckpoint` (or defaults to `0`).

`getLogSegmentForVersion` filters out unnecessary files and leaves [checkpoint](#isCheckpointFile) and [delta](#isDeltaFile) files only.

`getLogSegmentForVersion` filters out checkpoint files of size `0`.

`getLogSegmentForVersion` takes all the files that are [older than](#getFileVersion) the requested `versionToLoad`.

`getLogSegmentForVersion` splits the files into [checkpoint](#isCheckpointFile) and [delta](#isDeltaFile) files.

`getLogSegmentForVersion` finds the latest checkpoint from the list.

In the end, `getLogSegmentForVersion` creates a [LogSegment](LogSegment.md) with the (checkpoint and delta) files.

`getLogSegmentForVersion` is used when:

* `SnapshotManagement` is requested for [getLogSegmentFrom](#getLogSegmentFrom), [updateInternal](#updateInternal) and [getSnapshotAt](#getSnapshotAt)

### <span id="listFrom"> Listing Files from Version Upwards

```scala
listFrom(
  startVersion: Long): Iterator[FileStatus]
```

`listFrom`...FIXME

## <span id="createSnapshot"> Creating Snapshot

```scala
createSnapshot(
  segment: LogSegment,
  minFileRetentionTimestamp: Long,
  timestamp: Long): Snapshot
```

`createSnapshot` [readChecksum](ReadChecksum.md#readChecksum) (for the version of the given [LogSegment](LogSegment.md)) and creates a [Snapshot](Snapshot.md).

`createSnapshot` is used when `SnapshotManagement` is requested for [getSnapshotAtInit](#getSnapshotAtInit), [getSnapshotAt](#getSnapshotAt) and [update](#update).

## <span id="lastUpdateTimestamp"> Last Successful Update Timestamp

`SnapshotManagement` uses `lastUpdateTimestamp` internal registry for the timestamp of the last successful update.
