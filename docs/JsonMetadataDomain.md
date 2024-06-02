# JsonMetadataDomain

## toDomainMetadata { #toDomainMetadata }

```scala
toDomainMetadata[T: Manifest]: DomainMetadata
```

`toDomainMetadata` creates a [DomainMetadata](DomainMetadata.md) action for this [domainName](#domainName), a JSON representation of this object (of type [T](#T)) and the [removed](DomainMetadata.md#removed) flag disabled.

---

`toDomainMetadata` is used when:

* `ConflictChecker` is requested to [reassignOverlappingRowIds](ConflictChecker.md#reassignOverlappingRowIds)
* `RowId` is requested to [assignFreshRowIds](row-tracking/RowId.md#assignFreshRowIds)
* `ClusteredTableUtilsBase` is requested to [createDomainMetadata](liquid-clustering/ClusteredTableUtilsBase.md#createDomainMetadata) and [getClusteringDomainMetadataForAlterTableClusterBy](liquid-clustering/ClusteredTableUtilsBase.md#getClusteringDomainMetadataForAlterTableClusterBy)
