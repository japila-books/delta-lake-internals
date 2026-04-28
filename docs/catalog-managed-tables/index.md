# Catalog-Managed Tables

**Catalog-Managed Tables** are delta tables that are managed by a catalog.

The storage location of catalog-managed delta tables is fully owned by a catalog, and thus they are often referred to as **Catalog-Owned Tables**.

Catalog-managed tables are created with [CatalogOwnedTableFeature](CatalogOwnedTableFeature.md) table feature enabled using the following:

* Per delta table, using [delta.feature.catalogManaged](../table-features/TableFeatureProtocolUtils.md#FEATURE_PROP_PREFIX) table property
* Globally, using [spark.databricks.delta.properties.defaults.feature.catalogManaged](CatalogOwnedTableUtils.md#defaultCatalogOwnedEnabled) configuration property

[AbstractDeltaCatalog](../AbstractDeltaCatalog.md) can create catalog-managed delta tables when executed with [Unity Catalog](../AbstractDeltaCatalog.md#isUnityCatalog) and the table type is [MANAGED](../AbstractDeltaCatalog.md#managed-tables).

[CreateDeltaTableCommand](../commands/create-table/CreateDeltaTableCommand.md#run) makes sure that this table feature is enabled before creating a catalog-managed delta table (or `DELTA_UNSUPPORTED_CATALOG_MANAGED_TABLE_CREATION` error is thrown).

## Unsupported Commands

* [OPTIMIZE](../commands/optimize/index.md)
* [REORG](../commands/reorg/index.md)
* [VACUUM](../commands/vacuum/index.md)

## Learn More

* [Delta Transaction Log Protocol Specification]({{ delta.github }}/PROTOCOL.md#catalog-managed-tables)
* [Delta Lake Docs]({{ delta.docs }}/delta-catalog-managed-tables/)
* [[PROTOCOL RFC] Catalog-managed Tables]({{ delta.issues }}/4381)