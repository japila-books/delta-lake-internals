# CatalogOwnedTableUtils

## defaultCatalogOwnedEnabled { #defaultCatalogOwnedEnabled }

```scala
defaultCatalogOwnedEnabled(
  spark: SparkSession): Boolean
```

`defaultCatalogOwnedEnabled` checks whether [CatalogOwnedTableFeature](CatalogOwnedTableFeature.md) is enabled by default using the following configuration property:

```text
spark.databricks.delta.properties.defaults.feature.catalogManaged
```

The value of the configuration property (in the `RuntimeConfig` of the given `SparkSession`) can only be [supported](../table-features/TableFeatureProtocolUtils.md#FEATURE_PROP_SUPPORTED).

---

`defaultCatalogOwnedEnabled` is used when:

* `OptimisticTransactionImpl` is requested to [withGlobalConfigDefaults](../OptimisticTransactionImpl.md#withGlobalConfigDefaults)
* `CloneTableBase` is requested to [determineTargetProtocol](../commands/clone/CloneTableBase.md#determineTargetProtocol)
* `CreateDeltaTableCommand` is requested to [handleCreateTable](../commands/create-table/CreateDeltaTableCommand.md#handleCreateTable) and is [executed](../commands/create-table/CreateDeltaTableCommand.md#run)
* `CatalogOwnedTableUtils` is requested to [shouldEnableCatalogOwned](#shouldEnableCatalogOwned)
