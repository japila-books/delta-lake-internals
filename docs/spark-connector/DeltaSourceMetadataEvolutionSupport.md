# DeltaSourceMetadataEvolutionSupport

`DeltaSourceMetadataEvolutionSupport` is a marker extension of the [DeltaSourceBase](DeltaSourceBase.md) abstraction for [DeltaSources](#implementations) that [method](#method) and...FIXME.

## Implementations

* [DeltaSource](DeltaSource.md)

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
