---
title: ClusteredTableUtils
---

# ClusteredTableUtilsBase (ClusteredTableUtils)

## clusteringColumns { #PROP_CLUSTERING_COLUMNS }

`ClusteredTableUtilsBase` defines `clusteringColumns` value for the name of the table property with the clustering columns of a delta table.

`clusteringColumns` is used when:

* `ClusterBySpec` is requested to [toProperty](ClusterBySpec.md#toProperty)
* `ClusteredTableUtilsBase` is requested to [getClusterBySpecOptional](#getClusterBySpecOptional), [removeClusteringColumnsProperty](#removeClusteringColumnsProperty)

## Clustering Provider { #clusteringProvider }

```scala
clusteringProvider: String
```

`clusteringProvider` is always **liquid**.

---

`clusteringProvider` is used when:

* `OptimizeExecutor` is requested to [runOptimizeBinJob](../commands/optimize/OptimizeExecutor.md#runOptimizeBinJob)

## removeClusteringColumnsProperty { #removeClusteringColumnsProperty }

```scala
removeClusteringColumnsProperty(
  configuration: Map[String, String]): Map[String, String]
```

`removeClusteringColumnsProperty`...FIXME

---

`removeClusteringColumnsProperty` is used when:

* `CreateDeltaTableCommand` is requested for the [provided metadata](../commands/create-table/CreateDeltaTableCommand.md#getProvidedMetadata)

## Domain Metadata { #getDomainMetadataOptional }

```scala
getDomainMetadataOptional(
  table: CatalogTable,
  txn: OptimisticTransaction): Option[DomainMetadata] // (1)!
getDomainMetadataOptional(
  clusterBySpecOpt: Option[ClusterBySpec],
  txn: OptimisticTransaction): Option[DomainMetadata]
```

1. Uses [getClusterBySpecOptional](#getClusterBySpecOptional) with the given `CatalogTable` ([Spark SQL]({{ book.spark_sql }}/catalog/CatalogTable))

`getDomainMetadataOptional` [validateClusteringColumnsInStatsSchema](#validateClusteringColumnsInStatsSchema) in the given [ClusterBySpec](ClusterBySpec.md), if specified.

`getDomainMetadataOptional` [createDomainMetadata](#createDomainMetadata) with the [column names](ClusterBySpec.md#columnNames) (in the given [ClusterBySpec](ClusterBySpec.md)).

---

`getDomainMetadataOptional` is used when:

* `CreateDeltaTableCommand` is requested to [handleCreateTable](../commands/create-table/CreateDeltaTableCommand.md#handleCreateTable), [handleCreateTableAsSelect](../commands/create-table/CreateDeltaTableCommand.md#handleCreateTableAsSelect)

### Creating DomainMetadata { #createDomainMetadata }

```scala
createDomainMetadata(
  clusteringColumns: Seq[ClusteringColumn]): DomainMetadata
```

`createDomainMetadata` [creates a ClusteringMetadataDomain](ClusteringMetadataDomain.md#fromClusteringColumns) from the given `ClusteringColumn`s and [converts it to a DomainMetadata](../JsonMetadataDomain.md#toDomainMetadata).

## getClusterBySpecOptional { #getClusterBySpecOptional }

```scala
getClusterBySpecOptional(
  table: CatalogTable): Option[ClusterBySpec]
```

`getClusterBySpecOptional`...FIXME

---

`getClusterBySpecOptional` is used when:

* `CreateDeltaTableCommand` is requested to [handleCreateTableAsSelect](../commands/create-table/CreateDeltaTableCommand.md#handleCreateTableAsSelect)
* `ClusteredTableUtilsBase` is requested for the [domain metadata](#getDomainMetadataOptional)

## getClusteringColumnsAsProperty { #getClusteringColumnsAsProperty }

```scala
getClusteringColumnsAsProperty(
  maybeClusterBySpec: Option[ClusterBySpec]): Option[(String, String)]
```

`getClusteringColumnsAsProperty`...FIXME

---

`getClusteringColumnsAsProperty` is used when:

* `DeltaCatalog` is requested to [verifyTableAndSolidify](../DeltaCatalog.md#verifyTableAndSolidify)

## getTableFeatureProperties { #getTableFeatureProperties }

```scala
getTableFeatureProperties(
  existingProperties: Map[String, String]): Map[String, String]
```

`getTableFeatureProperties`...FIXME

---

`getTableFeatureProperties` is used when:

* `DeltaCatalog` is requested to [verifyTableAndSolidify](../DeltaCatalog.md#verifyTableAndSolidify)

## isSupported { #isSupported }

```scala
isSupported(
  protocol: Protocol): Boolean
```

`isSupported` requests the given [Protocol](../Protocol.md) to [isFeatureSupported](../table-features/TableFeatureSupport.md#isFeatureSupported) with [ClusteringTableFeature](ClusteringTableFeature.md).

---

`isSupported` is used when:

* `CreateDeltaTableCommand` is requested to [validatePrerequisitesForClusteredTable](../commands/create-table/CreateDeltaTableCommand.md#validatePrerequisitesForClusteredTable)
* `OptimizeExecutor` is requested to [isClusteredTable](../commands/optimize/OptimizeExecutor.md#isClusteredTable)
* [Optimize](../commands/optimize/index.md) command is executed
* `ClusteredTableUtilsBase` is requested to [validatePreviewEnabled](ClusteredTableUtilsBase.md#validatePreviewEnabled)

## validatePreviewEnabled { #validatePreviewEnabled }

```scala
validatePreviewEnabled(
  protocol: Protocol): Unit
validatePreviewEnabled(
  maybeClusterBySpec: Option[ClusterBySpec]): Unit
```

??? warning "Procedure"
    `validatePreviewEnabled` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`validatePreviewEnabled`...FIXME

---

`validatePreviewEnabled` is used when:

* [Optimize](../commands/optimize/index.md) command is executed
* `WriteIntoDelta` command is requested to [write data out (to a delta table)](../commands/WriteIntoDelta.md#write)
* `DeltaCatalog` is requested to [create a delta table](../DeltaCatalog.md#createDeltaTable) (and [validateClusterBySpec](../DeltaCatalog.md#validateClusterBySpec))
