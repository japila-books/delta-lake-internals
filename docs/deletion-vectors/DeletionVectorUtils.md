# DeletionVectorUtils

## deletionVectorsReadable { #deletionVectorsReadable }

```scala
deletionVectorsReadable(
  snapshot: SnapshotDescriptor,
  newProtocol: Option[Protocol] = None,
  newMetadata: Option[Metadata] = None): Boolean
deletionVectorsReadable(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`deletionVectorsReadable` is enabled (`true`) when the following all hold:

1. [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the given [Protocol](../Protocol.md)
1. The [format provider](../Metadata.md#format) is `parquet` (in the given [Metadata](../Metadata.md))

---

`deletionVectorsReadable` is used when:

* `ScanWithDeletionVectors` is requested to [dvEnabledScanFor](ScanWithDeletionVectors.md#dvEnabledScanFor)
* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)
* `DeletionVectorUtils` is requested to [isTableDVFree](#isTableDVFree), [fileIndexSupportsReadingDVs](#fileIndexSupportsReadingDVs)
* [RestoreTableCommand](../commands/restore/RestoreTableCommand.md) is executed
* `StatisticsCollection` is requested to [recompute](../StatisticsCollection.md#recompute)

## deletionVectorsWritable { #deletionVectorsWritable }

```scala
deletionVectorsWritable(
  snapshot: SnapshotDescriptor,
  newProtocol: Option[Protocol] = None,
  newMetadata: Option[Metadata] = None): Boolean
deletionVectorsWritable(
  protocol: Protocol,
  metadata: Metadata): Boolean
```

`deletionVectorsWritable` is enabled (`true`) when the following all hold:

1. [DeletionVectorsTableFeature](DeletionVectorsTableFeature.md) is [supported](../table-features/TableFeatureSupport.md#isFeatureSupported) by the given [Protocol](../Protocol.md)
1. [delta.enableDeletionVectors](../DeltaConfigs.md#ENABLE_DELETION_VECTORS_CREATION) is enabled in the table metadata (in the given [Metadata](../Metadata.md))

---

`deletionVectorsWritable` is used when:

* `OptimisticTransactionImpl` is requested to [getAssertDeletionVectorWellFormedFunc](../OptimisticTransactionImpl.md#getAssertDeletionVectorWellFormedFunc)
* [DeleteCommand](../commands/delete/index.md) is executed (and requested to [shouldWritePersistentDeletionVectors](../commands/delete/DeleteCommand.md#shouldWritePersistentDeletionVectors))

## isTableDVFree { #isTableDVFree }

```scala
isTableDVFree(
  spark: SparkSession,
  snapshot: Snapshot): Boolean
```

`isTableDVFree` indicates whether [Deletion Vectors](index.md) are present in the delta table (per the given [Snapshot](../Snapshot.md)).

!!! note
    Used only for [GenerateSymlinkManifest](../post-commit-hooks/GenerateSymlinkManifest.md).

`isTableDVFree` is `true` unless [deletionVectorsReadable](#deletionVectorsReadable) (in the given [Snapshot](../Snapshot.md)) and there are `deletionVector`s in the [allFiles](../Snapshot.md#allFiles) in the given [Snapshot](../Snapshot.md).

---

`isTableDVFree` is used when:

* `Protocol` is requested to [assertTablePropertyConstraintsSatisfied](../Protocol.md#assertTablePropertyConstraintsSatisfied) (with [compatibility.symlinkFormatManifest.enabled](../DeltaConfigs.md#compatibility.symlinkFormatManifest.enabled) enabled)
* `GenerateSymlinkManifestImpl` is requested to `generateFullManifest`
