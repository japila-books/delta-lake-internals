# DeltaSourceMetadataEvolutionSupport

`DeltaSourceMetadataEvolutionSupport` is an extension of the [DeltaSourceBase](DeltaSourceBase.md) abstraction to support [DeltaSources](#implementations).

## Implementations

* [DeltaSource](DeltaSource.md)

## trackingMetadataChange Flag { #trackingMetadataChange }

```scala
trackingMetadataChange: Boolean
```

`trackingMetadataChange` is enabled (`true`) when all the following hold:

1. [allowUnsafeStreamingReadOnColumnMappingSchemaChanges](SchemaReadOptions.md#allowUnsafeStreamingReadOnColumnMappingSchemaChanges) (of this [SchemaReadOptions](DeltaSourceBase.md#schemaReadOptions)) is disabled
2. There is a [PersistedMetadata](DeltaSourceMetadataTrackingLog.md#getCurrentTrackedMetadata) (of this [DeltaSourceMetadataTrackingLog](#metadataTrackingLog))

---

`trackingMetadataChange` is used when:

* `DeltaSource` is requested to [getFileChanges](DeltaSource.md#getFileChanges) and [getSnapshotAt](DeltaSource.md#getSnapshotAt)
* `DeltaSourceBase` is requested to [checkNonAdditiveSchemaChanges](DeltaSourceBase.md#checkNonAdditiveSchemaChanges), [checkReadIncompatibleSchemaChangeOnStreamStartOnce](DeltaSourceBase.md#checkReadIncompatibleSchemaChangeOnStreamStartOnce) and [getNextOffsetFromPreviousOffset](DeltaSourceBase.md#getNextOffsetFromPreviousOffset)
* `DeltaSourceCDCSupport` is requested to [getFileChangesForCDC](../change-data-feed/DeltaSourceCDCSupport.md#getFileChangesForCDC)
* `DeltaSourceMetadataEvolutionSupport` is requested to [getMetadataOrProtocolChangeIndexedFileIterator](#getMetadataOrProtocolChangeIndexedFileIterator) and [updateMetadataTrackingLogAndFailTheStreamIfNeeded](#updateMetadataTrackingLogAndFailTheStreamIfNeeded)

## initializeMetadataTrackingAndExitStream { #initializeMetadataTrackingAndExitStream }

```scala
initializeMetadataTrackingAndExitStream(
  batchStartVersion: Long,
  batchEndVersionOpt: Option[Long] = None,
  alwaysFailUponLogInitialized: Boolean = false): Unit
```

`initializeMetadataTrackingAndExitStream`...FIXME

---

`initializeMetadataTrackingAndExitStream` is used when:

* `DeltaSource` is requested to [validateAndInitMetadataLogForPlannedBatchesDuringStreamStart](DeltaSource.md#validateAndInitMetadataLogForPlannedBatchesDuringStreamStart)
* `DeltaSourceBase` is requested to [getStartingOffsetFromSpecificDeltaVersion](DeltaSourceBase.md#getStartingOffsetFromSpecificDeltaVersion)

## updateMetadataTrackingLogAndFailTheStreamIfNeeded { #updateMetadataTrackingLogAndFailTheStreamIfNeeded }

```scala
updateMetadataTrackingLogAndFailTheStreamIfNeeded(
  end: Offset): Unit
updateMetadataTrackingLogAndFailTheStreamIfNeeded(
  changedMetadataOpt: Option[Metadata],
  changedProtocolOpt: Option[Protocol],
  version: Long,
  replace: Boolean = false): Unit
```

`updateMetadataTrackingLogAndFailTheStreamIfNeeded`...FIXME

---

`updateMetadataTrackingLogAndFailTheStreamIfNeeded` is used when:

* `DeltaSource` is requested to [getSnapshotAt](DeltaSource.md#getSnapshotAt) and [commit](DeltaSource.md#commit)
