# Catalog-Managed Tables

**Catalog-Managed Tables** are delta tables with [CatalogOwnedTableFeature](CatalogOwnedTableFeature.md) table feature.

Catalog-managed tables are indirectly assumed to be owned by a catalog (and referred to as **catalog-owned tables**).

The feature started as part of [[PROTOCOL RFC] Catalog-managed Tables]({{ delta.issues }}/4381).

## Unsupported Commands

1. [OPTIMIZE](../commands/optimize/index.md)
1. [REORG](../commands/reorg/index.md)
1. [VACUUM](../commands/vacuum/index.md)
