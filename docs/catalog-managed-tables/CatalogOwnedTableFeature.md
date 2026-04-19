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

## validateDropInvariants { #validateDropInvariants }

??? note "TableFeature"

    ```scala
    validateDropInvariants(
      table: DeltaTableV2,
      snapshot: Snapshot): Boolean
    ```

    `validateDropInvariants` is part of the [TableFeature](../table-features/TableFeature.md#validateDropInvariants) abstraction.

`validateDropInvariants` is positive (`true`) when there are no [unbackfilledCommitsPresent](../coordinated-commits/CoordinatedCommitsUtils.md#unbackfilledCommitsPresent) for the given [Snapshot](../Snapshot.md).
