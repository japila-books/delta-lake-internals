---
title: FileNames
---

# FileNames Utility

## Staged Commit Directory for Log Path { #commitDirPath }

```scala
commitDirPath(
  logPath: Path): Path
```

`commitDirPath` creates a new `Path` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) for the [staged commit directory](#COMMIT_SUBDIR) under the given `logPath`.

---

`commitDirPath` is used when:

* `DeltaLog` is requested to [createLogDirectoriesIfNotExists](DeltaLog.md#createLogDirectoriesIfNotExists)
* `MetadataCleanup` is requested to [cleanUpExpiredLogs](./log-cleanup/MetadataCleanup.md#cleanUpExpiredLogs)
* `Snapshot` is requested to [assertLogFilesBelongToTable](./Snapshot.md#assertLogFilesBelongToTable)
* `VacuumCommandImpl` is requested to [getFilesFromDeltaLog](./commands/vacuum/VacuumCommandImpl.md#getFilesFromDeltaLog)
* `FileNames` is requested to [unbackfilledDeltaFile](#unbackfilledDeltaFile)

## Unbackfilled Delta File { #unbackfilledDeltaFile }

```scala
unbackfilledDeltaFile(
  logPath: Path,
  version: Long,
  uuidString: Option[String] = None): Path
```

`unbackfilledDeltaFile` creates a path of the following format:

```text
[logPath]/_staged_commits/[version].[uuid].json
```

---

`unbackfilledDeltaFile` [creates a staged commit directory](#commitDirPath) for the given `logPath`.

`unbackfilledDeltaFile` creates a new `Path` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) for `[version].[uuid].json` in the staged commit directory.

---

`unbackfilledDeltaFile` is used when:

* `DeltaCommitFileProvider` is requested to [deltaFile](./coordinated-commits/DeltaCommitFileProvider.md#deltaFile) and [listSortedUnbackfilledDeltaFiles](./coordinated-commits/DeltaCommitFileProvider.md#listSortedUnbackfilledDeltaFiles)

## <span id="_staged_commits"> Staged Commit Directory { #COMMIT_SUBDIR }

`FileNames` defines `_staged_commits` directory for staged commits.

Used when:

* `FileNames` is requested to [commitDirPath](#commitDirPath)
* `BackfilledDeltaFile` is requested to [extract the version from a Path](#BackfilledDeltaFile-unapply-path)
* `DeltaFile` extractor is requested to [unapply](#DeltaFile-unapply-path)
* `UnbackfilledDeltaFile` extractor is requested to [extract the version and UUID from a Path](#UnbackfilledDeltaFile-unapply-path)

## BackfilledDeltaFile { #BackfilledDeltaFile }

### Extract Version from FileStatus { #BackfilledDeltaFile-unapply }

```scala
unapply(
  f: FileStatus): Option[(FileStatus, Long)]
```

`unapply`...FIXME

---

`unapply` is used when:

* FIXME

### Extract Version from Path { #BackfilledDeltaFile-unapply-path }

```scala
unapply(
  path: Path): Option[(Path, Long)]
```

`unapply`...FIXME

---

`unapply` is used when:

* FIXME

## UnbackfilledDeltaFile { #UnbackfilledDeltaFile }

### Extract FileStatus Metadata { #UnbackfilledDeltaFile-unapply }

```scala
unapply(
  f: FileStatus): Option[(FileStatus, Long, String)]
```

`unapply` [destructures the path](#UnbackfilledDeltaFile-unapply-path) of the given `FileStatus` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)).

If successful, `unapply` returns a tuple of three elements:

1. The given `FileStatus`
1. `version`
1. `uuidString`

---

`unapply` is used when:

* `MetadataCleanup` is requested to [cleanUpExpiredLogs](./log-cleanup/MetadataCleanup.md#cleanUpExpiredLogs)
* `VacuumCommandImpl` is requested to [getFilesFromDeltaLog](./commands/vacuum/VacuumCommandImpl.md#getFilesFromDeltaLog)
* `CoordinatedCommitsUtils` is requested to [backfillWhenCoordinatedCommitsDisabled](./coordinated-commits/CoordinatedCommitsUtils.md#backfillWhenCoordinatedCommitsDisabled), [commitFilesIterator](./coordinated-commits/CoordinatedCommitsUtils.md#commitFilesIterator), [unbackfilledCommitsPresent](./coordinated-commits/CoordinatedCommitsUtils.md#unbackfilledCommitsPresent)
* `DeltaCommitFileProvider` is requested to [apply](./coordinated-commits/DeltaCommitFileProvider.md#apply)

### Extract Path Metadata { #UnbackfilledDeltaFile-unapply-path }

```scala
unapply(
  path: Path): Option[(Path, Long, String)]
```

`unapply` checks if the parent directory of the given `Path` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) is [_staged_commits](#COMMIT_SUBDIR).

If so, `unapply` destructures the given `path` (using [uuidDeltaFileRegex](#uuidDeltaFileRegex) regexp) into a tuple of three elements:

1. The given `Path`
1. `version`
1. `uuidString`

Otherwise, `unapply` is `None`.

---

`unapply` is used when:

* `FileNames` is requested to [isUnbackfilledDeltaFile](#isUnbackfilledDeltaFile) and [destructure FileStatus](#UnbackfilledDeltaFile-unapply)

## Creating Hadoop Path To Delta Commit File { #deltaFile }

```scala
deltaFile(
  path: Path,
  version: Long): Path
```

`deltaFile` creates a `Path` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) to a file in the `path` directory.

The format of the file is as follows:

```text
[version with leading 0s, up to 20 digits].json
```

Examples:

* `00000000000000000001.json`
* `00000000000000012345.json`

---

`deltaFile` is used when:

* `DeltaHistoryManager` is requested for [the history of a delta table](DeltaHistoryManager.md#getHistory) (and [getCommitInfo](DeltaHistoryManager.md#getCommitInfo))
* `OptimisticTransactionImpl` is requested to [commit large](OptimisticTransactionImpl.md#commitLarge) and to [commit](OptimisticTransactionImpl.md#doCommit) (and [write a commit file](OptimisticTransactionImpl.md#writeCommitFile))
* `SnapshotManagement` is requested for the [LogSegment for a given version](SnapshotManagement.md#getLogSegmentForVersion) (and [validateDeltaVersions](SnapshotManagement.md#validateDeltaVersions))
* [DESCRIBE DETAIL](commands/describe-detail/index.md) command is executed (and [describeDeltaTable](commands/describe-detail/DescribeDeltaDetailCommand.md#describeDeltaTable))

## Creating Hadoop Path To Compacted Delta File { #compactedDeltaFile }

```scala
compactedDeltaFile(
  path: Path,
  fromVersion: Long,
  toVersion: Long): Path
```

!!! note "Not used"

`compactedDeltaFile` creates a `Path` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) to a file in the `path` directory.

The format of the file is as follows:

```text
[fromVersion with leading 0s, up to 20 digits].[toVersion with leading 0s, up to 20 digits].compacted.json
```

Examples:

* `00000000000000000001.00000000000000012345.compacted.json`

<!---
## Review Me

a| [[checkpointPrefix]] Creates a Hadoop `Path` for a file name with a given `version`:

```
[version][%020d].checkpoint
```

E.g. `00000000000000000005.checkpoint`
-->
