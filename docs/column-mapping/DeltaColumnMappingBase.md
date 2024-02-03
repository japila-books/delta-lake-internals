# DeltaColumnMappingBase (DeltaColumnMapping)

`DeltaColumnMappingBase` is an abstraction of [DeltaColumnMappings](#implementations).

## Implementations

* [DeltaColumnMapping](#DeltaColumnMapping)

## <span id="MIN_PROTOCOL_VERSION"> Compatible Protocol

`DeltaColumnMappingBase` defines a [Protocol](../Protocol.md) (with [MIN_READER_VERSION](#MIN_READER_VERSION) and [MIN_WRITER_VERSION](#MIN_WRITER_VERSION)) as the minimum protocol version for the readers and writers to delta tables with [column mapping](index.md).

* `Protocol` utility is used for [requiredMinimumProtocol](../Protocol.md#requiredMinimumProtocol)
* [delta.columnMapping.mode](../table-properties/DeltaConfigs.md#COLUMN_MAPPING_MODE) configuration property
* [delta.columnMapping.maxColumnId](../table-properties/DeltaConfigs.md#COLUMN_MAPPING_MAX_ID) configuration property
* `DeltaErrors` is requested to [changeColumnMappingModeOnOldProtocol](../DeltaErrors.md#changeColumnMappingModeOnOldProtocol) (for error reporting)

### <span id="MIN_READER_VERSION"> Minimum Reader Version

`DeltaColumnMappingBase` defines `MIN_READER_VERSION` constant as `2` for the minimum version of the compatible readers of delta tables to [satisfyColumnMappingProtocol](#satisfyColumnMappingProtocol).

### <span id="MIN_WRITER_VERSION"> Minimum Writer Version

`DeltaColumnMappingBase` defines `MIN_WRITER_VERSION` constant as `5` for the minimum version of the compatible writers to delta tables to [satisfyColumnMappingProtocol](#satisfyColumnMappingProtocol).

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

`requiresNewProtocol` is `true` when the [DeltaColumnMappingMode](../Metadata.md#columnMappingMode) (of this delta table per the given [Metadata](../Metadata.md)) is either [IdMapping](DeltaColumnMappingMode.md#IdMapping) or [NameMapping](DeltaColumnMappingMode.md#NameMapping). Otherwise, `requiresNewProtocol` is `false`

`requiresNewProtocol` is used when:

* `Protocol` utility is used to [determine the required minimum protocol](../Protocol.md#requiredMinimumProtocol).

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
* [CreateDeltaTableCommand](../commands/create-table/CreateDeltaTableCommand.md) command is executed
* `ImplicitMetadataOperation` is requested to [update the metadata](../ImplicitMetadataOperation.md#updateMetadata)

## <span id="getPhysicalName"> Mapping Virtual to Physical Field Name

```scala
getPhysicalName(
  field: StructField): String
```

`getPhysicalName` requests the given `StructField` ([Spark SQL]({{ book.spark_sql }}/types/StructField/#metadata)) for the `Metadata` to extract `delta.columnMapping.physicalName` key, if available (for [column mapping](index.md)). Otherwise, `getPhysicalName` returns the name of the given `StructField` (with no name changes).

`getPhysicalName` is used when:

* `CheckpointV2` utility is used to [extractPartitionValues](../checkpoints/CheckpointV2.md#extractPartitionValues)
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

`tryFixMetadata` reads [columnMapping.mode](../table-properties/DeltaConfigs.md#columnMapping.mode) table property from the given `newMetadata` [table metadata](../table-properties/DeltaConfig.md#fromMetaData).

If the [DeltaColumnMappingMode](DeltaColumnMappingMode.md) is [IdMapping](DeltaColumnMappingMode.md#IdMapping) or [NameMapping](DeltaColumnMappingMode.md#NameMapping), `tryFixMetadata` [assignColumnIdAndPhysicalName](#assignColumnIdAndPhysicalName) with the given `newMetadata` and `oldMetadata` metadata and `isChangingModeOnExistingTable` flag.

For `NoMapping`, `tryFixMetadata` does nothing and returns the given `newMetadata`.

### <span id="satisfyColumnMappingProtocol"> satisfyColumnMappingProtocol

```scala
satisfyColumnMappingProtocol(
  protocol: Protocol): Boolean
```

`satisfyColumnMappingProtocol` returns `true` when all the following hold true:

1. [minWriterVersion](../Protocol.md#minWriterVersion) of the given `Protocol` is at least [5](#MIN_WRITER_VERSION)
1. [minReaderVersion](../Protocol.md#minReaderVersion) of the given `Protocol` is at least [2](#MIN_READER_VERSION)

### <span id="allowMappingModeChange"> Allowed Mapping Mode Change

```scala
allowMappingModeChange(
  oldMode: DeltaColumnMappingMode,
  newMode: DeltaColumnMappingMode): Boolean
```

`allowMappingModeChange` is `true` when either of the following holds true:

1. There is no mode change (and the old and new modes are the same)
1. There is a mode change from [NoMapping](DeltaColumnMappingMode.md#NoMapping) old mode to [NameMapping](DeltaColumnMappingMode.md#NameMapping)

Otherwise, `allowMappingModeChange` is `false`.

## <span id="DeltaColumnMapping"> DeltaColumnMapping

`DeltaColumnMapping` is the only [DeltaColumnMappingBase](#implementations).

## <span id="supportedModes"> Supported Column Mapping Modes

```scala
supportedModes: Set[DeltaColumnMappingMode]
```

`DeltaColumnMappingBase` defines `supportedModes` value with [NoMapping](DeltaColumnMappingMode.md#NoMapping) and [NameMapping](DeltaColumnMappingMode.md#NameMapping) column mapping modes.

`supportedModes` is used when:

* `DeltaColumnMappingBase` is requested to [verifyAndUpdateMetadataChange](#verifyAndUpdateMetadataChange) and [createPhysicalSchema](#createPhysicalSchema)

## <span id="getColumnMappingMetadata"> getColumnMappingMetadata

```scala
getColumnMappingMetadata(
  field: StructField,
  mode: DeltaColumnMappingMode): Metadata
```

!!! note
    `getColumnMappingMetadata` returns Spark SQL's [Metadata]({{ book.spark_sql }}/types/Metadata) not Delta Lake's.

`getColumnMappingMetadata`...FIXME

`getColumnMappingMetadata` is used when:

* `DeltaColumnMappingBase` is requested to [setColumnMetadata](#setColumnMetadata) and [createPhysicalSchema](#createPhysicalSchema)
