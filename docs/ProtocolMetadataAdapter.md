# ProtocolMetadataAdapter

`ProtocolMetadataAdapter` is an [abstraction](#contract) of [adapters](#implementations) for [DeltaParquetFileFormatBase](DeltaParquetFileFormatBase.md#protocolMetadataAdapter) to work alongside the two Spark Connector implementations:

* [Spark Connector V1](./spark-connector/index.md)
* [Kernel-based Spark Connector V2](./spark-connector-v2/index.md)

`ProtocolMetadataAdapter` hides the implementation details of [Protocol](./actions/Protocol.md) and [Metadata](./actions/Metadata.md) classes between the Delta Spark connectors.

## Contract

### assertTableReadable { #assertTableReadable }

```scala
assertTableReadable(
  sparkSession: SparkSession): Unit
```

Used when:

* `DeltaParquetFileFormatBase` is [created](DeltaParquetFileFormatBase.md)

### columnMappingMode { #columnMappingMode }

```scala
columnMappingMode: DeltaColumnMappingMode
```

[DeltaColumnMappingMode](./column-mapping/DeltaColumnMappingMode.md)

Used when:

* `DeltaParquetFileFormatBase` is [created](DeltaParquetFileFormatBase.md#columnMappingMode)

### createRowTrackingMetadataFields { #createRowTrackingMetadataFields }

```scala
createRowTrackingMetadataFields(
  nullableRowTrackingConstantFields: Boolean,
  nullableRowTrackingGeneratedFields: Boolean): Iterable[StructField]
```

Metadata columns for [Row Tracking](./row-tracking/index.md)

Used when:

* `DeltaParquetFileFormatBase` is requested for the [metadataSchemaFields](DeltaParquetFileFormatBase.md#metadataSchemaFields)

### getReferenceSchema { #getReferenceSchema }

```scala
getReferenceSchema: StructType
```

Used when:

* `DeltaParquetFileFormatBase` is [created](DeltaParquetFileFormatBase.md#referenceSchema)

### isDeletionVectorReadable { #isDeletionVectorReadable }

```scala
isDeletionVectorReadable: Boolean
```

Whether [Deletion Vectors](./deletion-vectors/index.md) are readable on this table

Used when:

* `DeltaParquetFileFormatBase` is requested for the [metadataSchemaFields](DeltaParquetFileFormatBase.md#metadataSchemaFields)

### isIcebergCompatAnyEnabled { #isIcebergCompatAnyEnabled }

```scala
isIcebergCompatAnyEnabled: Boolean
```

Whether any version of [IcebergCompat](./uniform/IcebergCompat.md) is enabled on this table

Used when:

* `DeltaParquetFileFormatBase` is requested to [prepareWrite](DeltaParquetFileFormatBase.md#prepareWrite)

### isIcebergCompatGeqEnabled { #isIcebergCompatGeqEnabled }

```scala
isIcebergCompatGeqEnabled(
  version: Int): Boolean
```

Whether [IcebergCompat](./uniform/IcebergCompat.md) is enabled at or above the specified version

Used when:

* `DeltaParquetFileFormatBase` is requested for the [prepareWrite](DeltaParquetFileFormatBase.md#prepareWrite)

### isRowIdEnabled { #isRowIdEnabled }

```scala
isRowIdEnabled: Boolean
```

Whether [Row Tracking](./row-tracking/index.md) is enabled on this table

Used when:

* `DeltaParquetFileFormatBase` is requested for the [metadataSchemaFields](DeltaParquetFileFormatBase.md#metadataSchemaFields)

## Implementations

* [ProtocolMetadataAdapterV1](./spark-connector/ProtocolMetadataAdapterV1.md)
* [ProtocolMetadataAdapterV2](./spark-connector-v2/ProtocolMetadataAdapterV2.md)
