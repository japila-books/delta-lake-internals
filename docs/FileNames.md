---
title: FileNames
---

# FileNames Utility

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
