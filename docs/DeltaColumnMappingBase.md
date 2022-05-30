# DeltaColumnMappingBase (DeltaColumnMapping)

## <span id="verifyAndUpdateMetadataChange"> verifyAndUpdateMetadataChange

```scala
verifyAndUpdateMetadataChange(
  oldProtocol: Protocol,
  oldMetadata: Metadata,
  newMetadata: Metadata,
  isCreatingNewTable: Boolean): Metadata
```

`verifyAndUpdateMetadataChange`...FIXME

`verifyAndUpdateMetadataChange` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](OptimisticTransactionImpl.md#updateMetadataInternal)

### <span id="tryFixMetadata"> tryFixMetadata

```scala
tryFixMetadata(
  oldMetadata: Metadata,
  newMetadata: Metadata,
  isChangingModeOnExistingTable: Boolean): Metadata
```

`tryFixMetadata`...FIXME
