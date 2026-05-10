# ProtocolMetadataAdapter

`ProtocolMetadataAdapter` is an [abstraction](#contract) of [adapters](#implementations) that hide implementation details of [Protocol](./actions/Protocol.md) and [Metadata](./actions/Metadata.md) classes between the two Spark Connectors: [Spark Connector V1](./spark-connector/index.md) and [Kernel-based Spark Connector V2](./spark-connector-v2/index.md).

## Contract (Subset)

### columnMappingMode { #columnMappingMode }

```scala
columnMappingMode: DeltaColumnMappingMode
```

[DeltaColumnMappingMode](./column-mapping/DeltaColumnMappingMode.md)

Used when:

* FIXME

### createRowTrackingMetadataFields { #createRowTrackingMetadataFields }

```scala
createRowTrackingMetadataFields(
  nullableRowTrackingConstantFields: Boolean,
  nullableRowTrackingGeneratedFields: Boolean): Iterable[StructField]
```

Metadata columns for [Row Tracking](./row-tracking/index.md)

Used when:

* FIXME

### isRowIdEnabled { #isRowIdEnabled }

```scala
isRowIdEnabled: Boolean
```

Whether [Row Tracking](./row-tracking/index.md) is enabled on this table

Used when:

* FIXME

### isDeletionVectorReadable { #isDeletionVectorReadable }

```scala
isDeletionVectorReadable: Boolean
```

Whether [Deletion Vectors](./deletion-vectors/index.md) are readable on this table

Used when:

* FIXME

### isIcebergCompatAnyEnabled { #isIcebergCompatAnyEnabled }

```scala
isIcebergCompatAnyEnabled: Boolean
```

Whether any version of [IcebergCompat](./uniform/IcebergCompat.md) is enabled on this table

Used when:

* FIXME

## Implementations

* [ProtocolMetadataAdapterV1](./spark-connector/ProtocolMetadataAdapterV1.md)
* [ProtocolMetadataAdapterV2](./spark-connector-v2/ProtocolMetadataAdapterV2.md)
