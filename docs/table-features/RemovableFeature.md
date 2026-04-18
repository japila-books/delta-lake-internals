---
title: RemovableFeature
---

# RemovableFeature Table Features

`RemovableFeature` is an [extension](#contract) of the [TableFeature](TableFeature.md) abstraction for [table features](#implementations) that can be removed.

## Implementations

* [CatalogOwnedTableFeature](../catalog-managed-tables/CatalogOwnedTableFeature.md)
* `CheckConstraintsTableFeature`
* `CheckpointProtectionTableFeature`
* `ColumnMappingTableFeature`
* `CoordinatedCommitsTableFeature`
* [DeletionVectorsTableFeature](../deletion-vectors/DeletionVectorsTableFeature.md)
* [DomainMetadataTableFeature](DomainMetadataTableFeature.md)
* [InCommitTimestampTableFeature](InCommitTimestampTableFeature.md)
* `MaterializePartitionColumnsTableFeature`
* `RedirectReaderWriterFeature`
* `RedirectWriterOnlyFeature`
* [RowTrackingFeature](../row-tracking/RowTrackingFeature.md)
* `TypeWideningTableFeatureBase`
* `V2CheckpointTableFeature`
* [VacuumProtocolCheckTableFeature](VacuumProtocolCheckTableFeature.md)

??? note "Sealed Trait"
    `RemovableFeature` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#sealed).
