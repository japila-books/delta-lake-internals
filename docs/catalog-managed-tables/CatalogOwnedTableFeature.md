---
title: CatalogOwnedTableFeature
---

# CatalogOwnedTableFeature Table Feature

`CatalogOwnedTableFeature` is a [ReaderWriterFeature](../table-features/ReaderWriterFeature.md) with [catalogManaged](../table-features/ReaderWriterFeature.md#name) name.

`CatalogOwnedTableFeature` is a [RemovableFeature](../table-features/RemovableFeature.md)

## requiredFeatures { #requiredFeatures }

??? note "TableFeature"

    ```scala
    requiredFeatures: Set[TableFeature]
    ```

    `requiredFeatures` is part of the [TableFeature](../table-features/TableFeature.md#requiredFeatures) abstraction.

`requiredFeatures` is a collection of the following [TableFeature](../table-features/TableFeature.md)s:

1. [InCommitTimestampTableFeature](../table-features/InCommitTimestampTableFeature.md)
1. [VacuumProtocolCheckTableFeature](../table-features/VacuumProtocolCheckTableFeature.md)
