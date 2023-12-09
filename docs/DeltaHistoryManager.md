# DeltaHistoryManager

`DeltaHistoryManager` is used for [version and commit history](#getHistory) of a [delta table](#deltaLog).

## Creating Instance

`DeltaHistoryManager` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* [Maximum Number of Keys (per List API Call)](#maxKeysPerList)

`DeltaHistoryManager` is created when:

* `DeltaLog` is requested for the [DeltaHistoryManager](DeltaLog.md#history)

### Maximum Number of Keys (per List API Call) { #maxKeysPerList }

`DeltaHistoryManager` can be given the number of keys per a `List` API call when [created](#creating-instance).

Unless given, `maxKeysPerList` is `1000`.

The value of `maxKeysPerList` can be configured using [spark.databricks.delta.history.maxKeysPerList](configuration-properties/index.md#spark.databricks.delta.history.maxKeysPerList) configuration property.

`maxKeysPerList` is used to [look up the active commit at a given time](#getActiveCommitAtTime) (in [parallelSearch](#parallelSearch)).

## Version and Commit History { #getHistory }

```scala
getHistory(
  start: Long,
  end: Option[Long] = None): Seq[CommitInfo]
getHistory(
  limitOpt: Option[Int]): Seq[CommitInfo]
```

`getHistory`...FIXME

`getHistory` is used when:

* `DeltaTableOperations` is requested to [executeHistory](DeltaTableOperations.md#executeHistory) (for [DeltaTable.history](DeltaTable.md#history) operator)
* [DescribeDeltaHistoryCommand](commands/describe-history/DescribeDeltaHistoryCommand.md) is executed (for [DESCRIBE HISTORY](sql/index.md#describe-history) SQL command)

### getCommitInfo { #getCommitInfo }

```scala
getCommitInfo(
  logStore: LogStore,
  basePath: Path,
  version: Long): CommitInfo
```

`getCommitInfo`...FIXME

## getActiveCommitAtTime { #getActiveCommitAtTime }

```scala
getActiveCommitAtTime(
  timestamp: Timestamp,
  canReturnLastCommit: Boolean,
  mustBeRecreatable: Boolean = true,
  canReturnEarliestCommit: Boolean = false): Commit
```

`getActiveCommitAtTime` determines the earliest commit to find based on the given `mustBeRecreatable` flag (default: `true`):

* When enabled (default), `getActiveCommitAtTime` [getEarliestRecreatableCommit](#getEarliestRecreatableCommit)
* When disabled, `getActiveCommitAtTime` [getEarliestDeltaFile](#getEarliestDeltaFile)

`getActiveCommitAtTime` requests the [DeltaLog](#deltaLog) to [update](SnapshotManagement.md#update) that gives the latest [Snapshot](Snapshot.md) that is requested for the [latest version](Snapshot.md#version).

`getActiveCommitAtTime` finds the commit. Based on how many commits to fetch (and the [maxKeysPerList](#maxKeysPerList)), `getActiveCommitAtTime` does [parallelSearch](#parallelSearch) or [not](#getCommits).

`getActiveCommitAtTime`...FIXME

---

`getActiveCommitAtTime` is used when:

* `DeltaTableUtils` utility is used to [resolveTimeTravelVersion](DeltaTableUtils.md#resolveTimeTravelVersion)
* `DeltaSource` is requested for [getStartingVersion](delta/DeltaSource.md#getStartingVersion)

### parallelSearch { #parallelSearch }

```scala
parallelSearch(
  time: Long,
  start: Long,
  end: Long): Commit
```

`parallelSearch` finds the latest `Commit` that happened at or before the given `time` in the range `[start, end)`.

`parallelSearch` [parallelSearch0](#parallelSearch0).

### parallelSearch0 { #parallelSearch0 }

```scala
parallelSearch0
```

`parallelSearch0`...FIXME
