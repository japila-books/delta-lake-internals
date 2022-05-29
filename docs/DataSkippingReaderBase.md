# DataSkippingReaderBase

`DataSkippingReaderBase` is an [extension](#contract) of the [DeltaScanGenerator](DeltaScanGenerator.md) abstraction for [DeltaScan generators](#implementations).

## Contract

### <span id="allFiles"> Dataset of AddFiles

```scala
allFiles: Dataset[AddFile]
```

`Dataset` of [AddFile](AddFile.md)s

Used when:

* `DataSkippingReaderBase` is requested to [withStatsInternal0](#withStatsInternal0), [withNoStats](#withNoStats), [getAllFiles](#getAllFiles), [filterOnPartitions](#filterOnPartitions), [getSpecificFilesWithStats](#getSpecificFilesWithStats)

### <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md)

Used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

[Metadata](Metadata.md)

Used when:

* `DataSkippingReaderBase` is requested for the [columnMappingMode](#columnMappingMode), and to [getStatsColumnOpt](#getStatsColumnOpt), [filesWithStatsForScan](#filesWithStatsForScan), [constructPartitionFilters](#constructPartitionFilters), [filterOnPartitions](#filterOnPartitions), [filesForScan](#filesForScan)

### <span id="numOfFiles"> numOfFiles

```scala
numOfFiles: Long
```

Used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

### <span id="path"> Path

```scala
path: Path
```

Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)

### <span id="redactedPath"> Redacted Path

```scala
redactedPath: String
```

Used when:

* `DataSkippingReaderBase` is requested to [withStatsCache](#withStatsCache)

### <span id="schema"> Schema

```scala
schema: StructType
```

Used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

### <span id="sizeInBytes"> sizeInBytes

```scala
sizeInBytes: Long
```

Used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

### <span id="version"> version

```scala
version: Long
```

Used when:

* `DataSkippingReaderBase` is requested to [withStatsCache](#withStatsCache), [filesForScan](#filesForScan)

## Implementations

* [Snapshot](Snapshot.md)

## <span id="useStats"><span id="spark.databricks.delta.stats.skipping"> spark.databricks.delta.stats.skipping

```scala
useStats: Boolean
```

`useStats` is the value of [spark.databricks.delta.stats.skipping](DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property.

`useStats` is used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

## <span id="filesForScan"> filesForScan

```scala
filesForScan(
  projection: Seq[Attribute],
  filters: Seq[Expression]): DeltaScan // (1)!
filesForScan(
  projection: Seq[Attribute],
  filters: Seq[Expression],
  keepNumRecords: Boolean): DeltaScan
```

1. `keepNumRecords` flag is `false`

`filesForScan`...FIXME

`filesForScan` is part of the [DeltaScanGeneratorBase](DeltaScanGeneratorBase.md#filesForScan) abstraction.

## <span id="columnMappingMode"> Column Mapping Mode

```scala
columnMappingMode: DeltaColumnMappingMode
```

`columnMappingMode` is the value of [columnMapping.mode](DeltaConfigs.md#COLUMN_MAPPING_MODE) table property (in the [Metadata](#metadata)).
