# PersistedMetadata

## Create PersistedMetadata { #apply }

```scala
apply(
  tableId: String,
  deltaCommitVersion: Long,
  metadata: Metadata,
  protocol: Protocol,
  sourceMetadataPath: String): PersistedMetadata
```

`apply`...FIXME

---

`apply` is used when:

* `DeltaSourceMetadataEvolutionSupport` is requested to [initializeMetadataTrackingAndExitStream](DeltaSourceMetadataEvolutionSupport.md#initializeMetadataTrackingAndExitStream) and [updateMetadataTrackingLogAndFailTheStreamIfNeeded](DeltaSourceMetadataEvolutionSupport.md#updateMetadataTrackingLogAndFailTheStreamIfNeeded)
