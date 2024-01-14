# SnapshotDescriptor

`SnapshotDescriptor` is an [abstraction](#contract) of [descriptions](#implementations) of the [versioned snapshots](#version) of a [delta table](#deltaLog).

## Contract

### <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md)

Used when:

* `GeneratedColumn` is requested to [generatePartitionFilters](generated-columns/GeneratedColumn.md#generatePartitionFilters) (for reporting purposes only)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

[Metadata](Metadata.md)

Used when:

* `GeneratedColumn` is requested to [generatePartitionFilters](generated-columns/GeneratedColumn.md#generatePartitionFilters)
* `SnapshotDescriptor` is requested for the [table schema](#schema)
* `TahoeFileIndex` is requested for the [partition schema](TahoeFileIndex.md#partitionSchema)

### <span id="protocol"> Protocol

```scala
protocol: Protocol
```

[Protocol](Protocol.md)

Used when:

* `GeneratedColumn` is requested to [generatePartitionFilters](generated-columns/GeneratedColumn.md#generatePartitionFilters)

### <span id="version"> Version

```scala
version: Long
```

Used when:

* `TahoeFileIndex` is requested for the [string representation](TahoeFileIndex.md#toString)

## Implementations

* [Snapshot](Snapshot.md)
* [TahoeFileIndex](TahoeFileIndex.md)

## <span id="schema"> Table Schema

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
