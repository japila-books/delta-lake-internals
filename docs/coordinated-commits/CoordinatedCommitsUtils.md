# CoordinatedCommitsUtils

## getCommitsFromCommitCoordinatorWithUsageLogs { #getCommitsFromCommitCoordinatorWithUsageLogs }

```scala
getCommitsFromCommitCoordinatorWithUsageLogs(
  deltaLog: DeltaLog,
  tableCommitCoordinatorClient: TableCommitCoordinatorClient,
  catalogTableOpt: Option[CatalogTable],
  startVersion: Long,
  versionToLoad: Option[Long],
  isAsyncRequest: Boolean): GetCommitsResponse
```

`getCommitsFromCommitCoordinatorWithUsageLogs`...FIXME

---

`getCommitsFromCommitCoordinatorWithUsageLogs` is used when:

* `SnapshotManagement` is requested to [listDeltaCompactedDeltaCheckpointFilesAndLatestChecksumFile](../SnapshotManagement.md#listDeltaCompactedDeltaCheckpointFilesAndLatestChecksumFile)

## commitFilesIterator { #commitFilesIterator }

```scala
commitFilesIterator(
  deltaLog: DeltaLog,
  catalogTableOpt: Option[CatalogTable],
  startVersion: Long): Iterator[(FileStatus, Long)]
```

`commitFilesIterator`...FIXME

---

`commitFilesIterator` is used when:

* `DeltaLog` is requested to [getChangeLogFiles](../DeltaLog.md#getChangeLogFiles)

## getCommitCoordinatorClient { #getCommitCoordinatorClient }

```scala
getCommitCoordinatorClient(
  spark: SparkSession,
  deltaLog: DeltaLog, // Used for logging
  metadata: Metadata,
  protocol: Protocol,
  failIfImplUnavailable: Boolean): Option[CommitCoordinatorClient]
```

`getCommitCoordinatorClient`...FIXME

---

`getCommitCoordinatorClient` is used when:

* `OptimisticTransactionImpl` is requested to [registerTableForCoordinatedCommitsIfNeeded](../OptimisticTransactionImpl.md#registerTableForCoordinatedCommitsIfNeeded)
* `CoordinatedCommitsUtils` is requested to [getTableCommitCoordinator](#getTableCommitCoordinator)

## getTableCommitCoordinator { #getTableCommitCoordinator }

```scala
getTableCommitCoordinator(
      spark: SparkSession,
      deltaLog: DeltaLog, // Used for logging
      snapshotDescriptor: SnapshotDescriptor,
      failIfImplUnavailable: Boolean): Option[TableCommitCoordinatorClient]
```

`getTableCommitCoordinator`...FIXME

---

`getTableCommitCoordinator` is used when:

* `Snapshot` is requested for a [TableCommitCoordinatorClient](../Snapshot.md#tableCommitCoordinatorClientOpt)

## getCoordinatedCommitsConfs { #getCoordinatedCommitsConfs }

```scala
getCoordinatedCommitsConfs(
  metadata: Metadata): (Option[String], Map[String, String])
```

`getCoordinatedCommitsConfs`...FIXME

---

`getCoordinatedCommitsConfs` is used when:

* `OptimisticTransactionImpl` is requested to [registerTableForCoordinatedCommitsIfNeeded](../OptimisticTransactionImpl.md#registerTableForCoordinatedCommitsIfNeeded)

## unbackfilledCommitsPresent { #unbackfilledCommitsPresent }

```scala
unbackfilledCommitsPresent(
  snapshot: Snapshot): Boolean
```

`unbackfilledCommitsPresent` is enabled (`true`) when there are [unbackfilled delta files](../FileNames.md#UnbackfilledDeltaFile) (files in `_staged_commits` directory).

---

`unbackfilledCommitsPresent` is used when:

* FIXME
