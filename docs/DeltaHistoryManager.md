# DeltaHistoryManager

`DeltaHistoryManager` is used for [version and commit history](#getHistory) of a [delta table](#deltaLog).

## Creating Instance

`DeltaHistoryManager` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="maxKeysPerList"> Maximum number of keys (default: `1000`)

`DeltaHistoryManager` is created when:

* `DeltaLog` is requested for [one](DeltaLog.md#history)
* `DeltaTableOperations` is requested to [execute history command](DeltaTableOperations.md#executeHistory)

## <span id="getHistory"> Version and Commit History

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
* [DescribeDeltaHistoryCommand](commands/describe-history/DescribeDeltaHistoryCommand.md) is executed (for [DESCRIBE HISTORY](sql/index.md#DESCRIBE-HISTORY) SQL command)

### <span id="getCommitInfo"> getCommitInfo Utility

```scala
getCommitInfo(
  logStore: LogStore,
  basePath: Path,
  version: Long): CommitInfo
```

`getCommitInfo`...FIXME

## <span id="getActiveCommitAtTime"> getActiveCommitAtTime

```scala
getActiveCommitAtTime(
  timestamp: Timestamp,
  canReturnLastCommit: Boolean,
  mustBeRecreatable: Boolean = true,
  canReturnEarliestCommit: Boolean = false): Commit
```

`getActiveCommitAtTime`...FIXME

`getActiveCommitAtTime` is used when:

* `DeltaTableUtils` utility is used to [resolveTimeTravelVersion](DeltaTableUtils.md#resolveTimeTravelVersion)
* `DeltaSource` is requested for [getStartingVersion](DeltaSource.md#getStartingVersion)
