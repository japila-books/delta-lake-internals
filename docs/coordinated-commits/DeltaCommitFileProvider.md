# DeltaCommitFileProvider

## deltaFile { #deltaFile }

```scala
deltaFile(
  version: Long): Path
```

`deltaFile` looks up the given `version` (in the [uuids](#uuids) registry).

When found, `deltaFile` [creates an unbackfilledDeltaFile](../FileNames.md#unbackfilledDeltaFile) for this [resolvedPath](#resolvedPath), the given `version` and the found uuid.

Otherwise, `deltaFile` [creates a unsafeDeltaFile](../FileNames.md#unsafeDeltaFile) for this [resolvedPath](#resolvedPath) and the given `version`.

??? note "IllegalStateException"
    `deltaFile` reports an `IllegalStateException` when the given `version` is higher than this [maxVersionInclusive](#maxVersionInclusive).

    ```text
    Cannot resolve Delta table at version [version] as the state is currently at version [maxVersionInclusive].
    The requested version may be incorrect or the state may be outdated.
    Please verify the requested version, update the state if necessary, and try again
    ```

---

`deltaFile` is used when:

* `DeltaHistoryManager` is requested to [getFirstCommitAndICTAfter](../DeltaHistoryManager.md#getFirstCommitAndICTAfter) and [getHistoryImpl](../DeltaHistoryManager.md#getHistoryImpl)
* `OptimisticTransactionImpl` is requested to [commitLarge](../OptimisticTransactionImpl.md#commitLarge)
* `Snapshot` is requested to [getInCommitTimestampOpt](../Snapshot.md#getInCommitTimestampOpt)
* `DescribeDeltaDetailCommand` is requested to [describeDeltaTable](../commands/describe-detail/DescribeDeltaDetailCommand.md#describeDeltaTable)
* `VacuumCommandImpl` is requested to [setCommitClock](../commands/vacuum/VacuumCommandImpl.md#setCommitClock)

## apply { #apply }

```scala
apply(
  snapshot: Snapshot): DeltaCommitFileProvider
```

`apply` creates a [DeltaCommitFileProvider](DeltaCommitFileProvider.md) based on the given [Snapshot](../Snapshot.md):

* [Path](../Snapshot.md#path)
* [Version](../Snapshot.md#version)
* [UnbackfilledDeltaFile](../FileNames.md#UnbackfilledDeltaFile)s off of the [deltas](../LogSegment.md#deltas) of the [LogSegment](../Snapshot.md#logSegment) of the given [Snapshot](../Snapshot.md)

---

`apply` is used when:

* `DeltaHistoryManager` is requested to [getActiveCommitAtTime](../DeltaHistoryManager.md#getActiveCommitAtTime) and [getHistory](../DeltaHistoryManager.md#getHistory)
* `OptimisticTransactionImpl` is requested to [commitLarge](../OptimisticTransactionImpl.md#commitLarge)
* `Snapshot` is requested to [ensureCommitFilesBackfilled](../Snapshot.md#ensureCommitFilesBackfilled) and [getInCommitTimestampOpt](../Snapshot.md#getInCommitTimestampOpt)
* `DescribeDeltaDetailCommand` is requested to [describeDeltaTable](../commands/describe-detail/DescribeDeltaDetailCommand.md#describeDeltaTable)
* `VacuumCommandImpl` is requested to [setCommitClock](../commands/vacuum/VacuumCommandImpl.md#setCommitClock)
