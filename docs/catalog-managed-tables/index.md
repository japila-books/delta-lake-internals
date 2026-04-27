# Catalog-Managed Tables

**Catalog-Managed Tables** are delta tables with [CatalogOwnedTableFeature](CatalogOwnedTableFeature.md) table feature.

Catalog-managed tables are assumed to be owned by a catalog, and thus referred to as **Catalog-Owned Tables**.

!!! note "Delta Transaction Log Protocol Specification"
    Catalog-Managed Tables feature is described in [Catalog-managed tables]({{ delta.github }}/PROTOCOL.md#catalog-managed-tables) in [Delta Transaction Log Protocol]({{ delta.github }}/PROTOCOL.md) specification.

## Unsupported Commands

1. [OPTIMIZE](../commands/optimize/index.md)
1. [REORG](../commands/reorg/index.md)
1. [VACUUM](../commands/vacuum/index.md)

## Learn More

1. [Delta Lake Docs]({{ delta.docs }}/delta-catalog-managed-tables/)
1. [[PROTOCOL RFC] Catalog-managed Tables]({{ delta.issues }}/4381)