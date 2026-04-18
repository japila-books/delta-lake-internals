# SnapshotDescriptor

`SnapshotDescriptor` is an [abstraction](#contract) of [descriptions](#implementations) of the [versioned snapshots](#version) of a [delta table](#deltaLog).

## Contract

### DeltaLog { #deltaLog }

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md)

Used when:

* `GeneratedColumn` is requested to [generatePartitionFilters](generated-columns/GeneratedColumn.md#generatePartitionFilters) (for reporting purposes only)

### Metadata { #metadata }

```scala
metadata: Metadata
```

[Metadata](Metadata.md)

Used when:

* `GeneratedColumn` is requested to [generatePartitionFilters](generated-columns/GeneratedColumn.md#generatePartitionFilters)
* `SnapshotDescriptor` is requested for the [table schema](#schema)
* `TahoeFileIndex` is requested for the [partition schema](TahoeFileIndex.md#partitionSchema)

### Protocol { #protocol }

```scala
protocol: Protocol
```

[Protocol](Protocol.md)

Used when:

* `GeneratedColumn` is requested to [generatePartitionFilters](generated-columns/GeneratedColumn.md#generatePartitionFilters)

### Version { #version }

```scala
version: Long
```

Used when:

* `TahoeFileIndex` is requested for the [string representation](TahoeFileIndex.md#toString)

## Implementations

* [Snapshot](Snapshot.md)
* [TahoeFileIndex](TahoeFileIndex.md)

## Table Schema { #schema }

```scala
schema: StructType
```

`schema` requests the [Metadata](#metadata) for the [table schema](Metadata.md#schema).

---

`schema` is used when:

* `DeltaCatalog` is requested to [alterTable](DeltaCatalog.md#alterTable)
* `DeltaTableV2` is requested for the [table schema](DeltaTableV2.md#tableSchema)
* `ShowTableColumnsCommand` is executed
* `TahoeLogFileIndex` is requested to [getSnapshot](TahoeLogFileIndex.md#getSnapshot)
* `DeltaDataSource` is requested for the [source schema](spark-connector/DeltaDataSource.md#sourceSchema) and [createSource](spark-connector/DeltaDataSource.md#createSource)
* `DeltaSourceBase` is requested for the [table schema](spark-connector/DeltaSourceBase.md#schema), [checkColumnMappingSchemaChangesOnStreamStartOnce](spark-connector/DeltaSourceBase.md#checkColumnMappingSchemaChangesOnStreamStartOnce) (for reporting purposes)

## isCatalogOwned { #isCatalogOwned }

```scala
isCatalogOwned: Boolean
```

`isCatalogOwned` is enabled (`true`) when all the following holds:

1. [version](#version) is at least `0`
1. [CatalogOwnedTableFeature](catalog-managed-tables/CatalogOwnedTableFeature.md) is among the [reader and writer features](./table-features/TableFeatureSupport.md#readerAndWriterFeatureNames) (of this [Protocol](#protocol))

---

`isCatalogOwned` is used when:

* `OptimisticTransactionImpl` is requested to [isUCManagedTable](OptimisticTransactionImpl.md#isUCManagedTable)
* `Snapshot` is requested to [ensureCommitFilesBackfilled](Snapshot.md#ensureCommitFilesBackfilled)
* `SnapshotManagement` is requested to [getUpdatedSnapshot](SnapshotManagement.md#getUpdatedSnapshot) and [populateCommitCoordinator](SnapshotManagement.md#populateCommitCoordinator)
* `CreateDeltaTableCommand` is requested to [replaceMetadataIfNecessary](./commands/create-table/CreateDeltaTableCommand.md#replaceMetadataIfNecessary)
* `DeltaReorgTableCommand` command is [executed](./commands/reorg/DeltaReorgTableCommand.md#run)
* `OptimizeTableCommand` command is [executed](./commands/optimize/OptimizeTableCommand.md#run)
* `VacuumCommand` command is [executed](./commands/vacuum/VacuumCommand.md#run)
* `CatalogOwnedTableUtils` is requested to [populateTableCommitCoordinatorFromCatalog](./catalog-managed-tables/CatalogOwnedTableUtils.md#populateTableCommitCoordinatorFromCatalog), [validatePropertiesForAlterTableSetPropertiesDeltaCommand](./catalog-managed-tables/CatalogOwnedTableUtils.md#validatePropertiesForAlterTableSetPropertiesDeltaCommand), [validatePropertiesForAlterTableUnsetPropertiesDeltaCommand](./catalog-managed-tables/CatalogOwnedTableUtils.md#validatePropertiesForAlterTableUnsetPropertiesDeltaCommand) and [validatePropertiesForCreateDeltaTableCommand](./catalog-managed-tables/CatalogOwnedTableUtils.md#validatePropertiesForCreateDeltaTableCommand)
* `CoordinatedCommitsUtils` is requested to [backfillWhenCoordinatedCommitsDisabled](./coordinated-commits/CoordinatedCommitsUtils.md#backfillWhenCoordinatedCommitsDisabled) and [commitFilesIterator](./coordinated-commits/CoordinatedCommitsUtils.md#commitFilesIterator)
* `TransactionHelper` is requested to [createCoordinatedCommitsStats](TransactionHelper.md#createCoordinatedCommitsStats) and [readSnapshotTableCommitCoordinatorClientOpt](TransactionHelper.md#readSnapshotTableCommitCoordinatorClientOpt)
