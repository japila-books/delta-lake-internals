# DeltaColumnMappingBase (DeltaColumnMapping)

`DeltaColumnMappingBase` is an abstraction of [DeltaColumnMappings](#implementations).

## Implementations

* [DeltaColumnMapping](#DeltaColumnMapping)

## <span id="createPhysicalSchema"> createPhysicalSchema

```scala
createPhysicalSchema(
  schema: StructType,
  referenceSchema: StructType,
  columnMappingMode: DeltaColumnMappingMode,
  checkSupportedMode: Boolean = true): StructType
```

`createPhysicalSchema`...FIXME

`createPhysicalSchema` is used when:

* `DeltaColumnMappingBase` is requested to [checkColumnIdAndPhysicalNameAssignments](#checkColumnIdAndPhysicalNameAssignments) and [createPhysicalAttributes](#createPhysicalAttributes)
* `DeltaParquetFileFormat` is requested to [prepare a schema](../DeltaParquetFileFormat.md#prepareSchema)

## <span id="renameColumns"> renameColumns

```scala
renameColumns(
  schema: StructType): StructType
```

`renameColumns`...FIXME

`renameColumns` is used when:

* `Metadata` is requested for the [physicalPartitionSchema](../Metadata.md#physicalPartitionSchema)

## <span id="requiresNewProtocol"> requiresNewProtocol

```scala
requiresNewProtocol(
  metadata: Metadata): Boolean
```

`requiresNewProtocol`...FIXME

`requiresNewProtocol` is used when:

* `Protocol` utility is used for the [required minimum protocol](../Protocol.md#requiredMinimumProtocol)

## <span id="checkColumnIdAndPhysicalNameAssignments"> checkColumnIdAndPhysicalNameAssignments

```scala
checkColumnIdAndPhysicalNameAssignments(
  schema: StructType,
  mode: DeltaColumnMappingMode): Unit
```

`checkColumnIdAndPhysicalNameAssignments`...FIXME

`checkColumnIdAndPhysicalNameAssignments` is used when:

* `OptimisticTransactionImpl` is requested to [verify the new metadata](../OptimisticTransactionImpl.md#verifyNewMetadata)

## <span id="dropColumnMappingMetadata"> dropColumnMappingMetadata

```scala
dropColumnMappingMetadata(
  schema: StructType): StructType
```

`dropColumnMappingMetadata`...FIXME

`dropColumnMappingMetadata` is used when:

* `DeltaLog` is requested for a [BaseRelation](../DeltaLog.md#createRelation) and for a [DataFrame](../DeltaLog.md#createDataFrame)
* `DeltaTableV2` is requested for the [tableSchema](../DeltaTableV2.md#tableSchema)
* [AlterTableSetLocationDeltaCommand](../commands/alter/AlterTableSetLocationDeltaCommand.md) command is executed
* [CreateDeltaTableCommand](../commands/CreateDeltaTableCommand.md) command is executed
* `ImplicitMetadataOperation` is requested to [update the metadata](../ImplicitMetadataOperation.md#updateMetadata)

## <span id="getPhysicalName"> Mapping Virtual to Physical Field Name

```scala
getPhysicalName(
  field: StructField): String
```

`getPhysicalName` requests the given `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField/#metadata)) for the `Metadata` to extract `delta.columnMapping.physicalName` key if available. Otherwise, `getPhysicalName` does nothing and returns the name of the given `StructField`.

`getPhysicalName` is used when:

* `CheckpointV2` utility is used to [extractPartitionValues](../CheckpointV2.md#extractPartitionValues)
* `ConflictChecker` is requested to [getPrettyPartitionMessage](../ConflictChecker.md#getPrettyPartitionMessage)
* `DeltaColumnMappingBase` is requested to [renameColumns](#renameColumns), [assignPhysicalNames](#assignPhysicalNames) and [createPhysicalSchema](#createPhysicalSchema)
* `DeltaLog` utility is used to [rewritePartitionFilters](../DeltaLog.md#rewritePartitionFilters)
* [AlterTableChangeColumnDeltaCommand](../commands/alter/AlterTableChangeColumnDeltaCommand.md) is executed
* `ConvertToDeltaCommand` utility is used to [create an AddFile](../commands/convert/ConvertToDeltaCommand.md#createAddFile)
* `TahoeFileIndex` is requested to [makePartitionDirectories](../TahoeFileIndex.md#makePartitionDirectories)
* `DataSkippingReaderBase` is requested to [getStatsColumnOpt](../data-skipping/DataSkippingReaderBase.md#getStatsColumnOpt)
* `StatisticsCollection` is requested to [collect statistics](../StatisticsCollection.md#collectStats)

## <span id="verifyAndUpdateMetadataChange"> verifyAndUpdateMetadataChange

```scala
verifyAndUpdateMetadataChange(
  oldProtocol: Protocol,
  oldMetadata: Metadata,
  newMetadata: Metadata,
  isCreatingNewTable: Boolean): Metadata
```

`verifyAndUpdateMetadataChange`...FIXME

In the end, `verifyAndUpdateMetadataChange` [tryFixMetadata](#tryFixMetadata) with the given `newMetadata` and `oldMetadata` metadata.

`verifyAndUpdateMetadataChange` is used when:

* `OptimisticTransactionImpl` is requested to [updateMetadataInternal](../OptimisticTransactionImpl.md#updateMetadataInternal)

### <span id="tryFixMetadata"> tryFixMetadata

```scala
tryFixMetadata(
  oldMetadata: Metadata,
  newMetadata: Metadata,
  isChangingModeOnExistingTable: Boolean): Metadata
```

`tryFixMetadata` reads [columnMapping.mode](../DeltaConfigs.md#columnMapping.mode) table property from the given `newMetadata` [table metadata](../DeltaConfig.md#fromMetaData).

If the [DeltaColumnMappingMode](DeltaColumnMappingMode.md) is [IdMapping](DeltaColumnMappingMode.md#IdMapping) or [NameMapping](DeltaColumnMappingMode.md#NameMapping), `tryFixMetadata` [assignColumnIdAndPhysicalName](#assignColumnIdAndPhysicalName) with the given `newMetadata` and `oldMetadata` metadata and `isChangingModeOnExistingTable` flag.

For `NoMapping`, `tryFixMetadata` does nothing and returns the given `newMetadata`.

## <span id="DeltaColumnMapping"> DeltaColumnMapping

`DeltaColumnMapping` is the only [DeltaColumnMappingBase](#implementations).
