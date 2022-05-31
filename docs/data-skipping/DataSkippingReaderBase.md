# DataSkippingReaderBase

`DataSkippingReaderBase` is an [extension](#contract) of the [DeltaScanGenerator](../DeltaScanGenerator.md) abstraction for [DeltaScan generators](#implementations).

## Contract

### <span id="allFiles"> Dataset of AddFiles

```scala
allFiles: Dataset[AddFile]
```

`Dataset` of [AddFile](../AddFile.md)s

Used when:

* `DataSkippingReaderBase` is requested to [withStatsInternal0](#withStatsInternal0), [withNoStats](#withNoStats), [getAllFiles](#getAllFiles), [filterOnPartitions](#filterOnPartitions), [getSpecificFilesWithStats](#getSpecificFilesWithStats)

### <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

[DeltaLog](../DeltaLog.md)

Used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

[Metadata](../Metadata.md)

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

* [Snapshot](../Snapshot.md)

## <span id="useStats"><span id="spark.databricks.delta.stats.skipping"> spark.databricks.delta.stats.skipping

```scala
useStats: Boolean
```

`useStats` is the value of [spark.databricks.delta.stats.skipping](../DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property.

`useStats` is used when:

* `DataSkippingReaderBase` is requested to [filesForScan](#filesForScan)

## <span id="withStats"> withStats DataFrame

```scala
withStats: DataFrame
```

`withStats` [withStatsInternal](#withStatsInternal).

`withStats` is used when:

* `DataSkippingReaderBase` is requested to [filesWithStatsForScan](#filesWithStatsForScan), [getAllFiles](#getAllFiles), [filterOnPartitions](#filterOnPartitions) and [getDataSkippedFiles](#getDataSkippedFiles)

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

`filesForScan` is part of the [DeltaScanGeneratorBase](../DeltaScanGeneratorBase.md#filesForScan) abstraction.

`filesForScan` branches off based on the given `filters` expressions and the [schema](#schema).

If the given `filters` expressions are either `TrueLiteral` or empty, or the [schema](#schema) is empty, `filesForScan` executes [delta.skipping.none](#delta.skipping.none) code path.

If there are partition-based filter expressions only (among the `filters` expressions), `filesForScan` executes [delta.skipping.partition](#delta.skipping.partition) code path. Otherwise, `filesForScan` executes [delta.skipping.data](#delta.skipping.data) code path.

### <span id="delta.skipping.none"> No Data Skipping

`filesForScan`...FIXME

### <span id="delta.skipping.partition"> delta.skipping.partition

`filesForScan`...FIXME

### <span id="delta.skipping.data"> delta.skipping.data

`filesForScan` [constructs the final partition filters](#constructPartitionFilters) with the partition filters (of the given `filters` expressions).

With [spark.databricks.delta.stats.skipping](#useStats) configuration property enabled, `filesForScan` [creates a file skipping predicate expression](#constructDataFilters) for every data filter.

`filesForScan` [getDataSkippedFiles](#getDataSkippedFiles) for the final partition-only and data skipping filters (that leverages data skipping statistics to find the set of parquet files that need to be queried).

In the end, creates a [DeltaScan](DeltaScan.md) (with the [files and sizes](#getDataSkippedFiles), and `dataSkippingOnlyV1` or `dataSkippingAndPartitionFilteringV1` data skipping types).

#### <span id="getDataSkippedFiles"> getDataSkippedFiles

```scala
getDataSkippedFiles(
  partitionFilters: Column,
  dataFilters: DataSkippingPredicate,
  keepNumRecords: Boolean): (Seq[AddFile], Seq[DataSize])
```

`getDataSkippedFiles` [builds the size collectors and the filter functions](#buildSizeCollectorFilter):

 Size Collector | Filter Function
----------------|----------------
 totalSize      | totalFilter
 partitionSize  | partitionFilter
 scanSize       | scanFilter

??? note "Size Collectors are Accumulators"
    The size collectors are `ArrayAccumulator`s that are `AccumulatorV2`s ([Spark Core]({{ book.spark_core }}/accumulators/AccumulatorV2)).

    ```scala
    class ArrayAccumulator(val size: Int)
    extends AccumulatorV2[(Int, Long), Array[Long]]
    ```

`getDataSkippedFiles` takes the [withStats DataFrame](#withStats) adds the following`WHERE` clauses (and creates a `filteredFiles` dataset):

1. The above `totalFilter` with `trueLiteral`
1. The above `partitionFilter` with the given `partitionFilters`
1. The above `scanFilter` with the given `dataFilters` and a negation of [verifyStatsForFilter](#verifyStatsForFilter)

`getDataSkippedFiles` adds `stats` column that includes `numRecords` stats when the given `keepNumRecords` flag is enabled.

??? note "keepNumRecords Flag is Disabled"
    The given `keepNumRecords` flag is always off (`false`).

In the end, `getDataSkippedFiles` returns the rows (as [AddFile](../AddFile.md)s) and the `DataSize`s based on the following `ArrayAccumulator`s:

1. `totalSize`
1. `partitionSize`
1. `scanSize`

??? note "Dataset.collect"
    `getDataSkippedFiles` uses `Dataset.collect` action to collect the rows that runs the Spark SQL query and  runs a Spark job.

### <span id="buildSizeCollectorFilter"> buildSizeCollectorFilter

```scala
buildSizeCollectorFilter(): (ArrayAccumulator, Column => Column)
```

`buildSizeCollectorFilter`...FIXME

### <span id="verifyStatsForFilter"> verifyStatsForFilter

```scala
verifyStatsForFilter(
  referencedStats: Set[StatsColumn]): Column
```

`verifyStatsForFilter`...FIXME

## <span id="columnMappingMode"> Column Mapping Mode

```scala
columnMappingMode: DeltaColumnMappingMode
```

`columnMappingMode` is the value of [columnMapping.mode](../DeltaConfigs.md#COLUMN_MAPPING_MODE) table property (in the [Metadata](#metadata)).
