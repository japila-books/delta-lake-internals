# DataSkippingReaderBase

`DataSkippingReaderBase` is an [extension](#contract) of the [DeltaScanGenerator](DeltaScanGenerator.md) abstraction for [DeltaScan generators](#implementations).

The heart of `DataSkippingReaderBase` (and [Data Skipping](index.md) in general) is the [withStats DataFrame](#withStats).

## Contract

### <span id="allFiles"> allFiles Dataset (of AddFiles)

```scala
allFiles: Dataset[AddFile]
```

`Dataset` of [AddFile](../AddFile.md)s

See:

* [Snapshot](../Snapshot.md#allFiles)

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

### <span id="numOfFilesOpt"> numOfFilesOpt

```scala
numOfFilesOpt: Option[Long]
```

See:

* [Snapshot](../Snapshot.md#numOfFilesOpt)

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

See:

* [SnapshotDescriptor](../SnapshotDescriptor.md#schema)

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

## <span id="useStats"><span id="spark.databricks.delta.stats.skipping"> stats.skipping

`DataSkippingReaderBase` uses [spark.databricks.delta.stats.skipping](../DeltaSQLConf.md#DELTA_STATS_SKIPPING) configuration property for [filesForScan](#filesForScan).

## <span id="withStats"> withStats DataFrame

```scala
withStats: DataFrame
```

`withStats` [withStatsInternal](#withStatsInternal).

??? note "Final Method"
    `withStats` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

---

`withStats` is used when:

* `DataSkippingReaderBase` is requested to [filesWithStatsForScan](#filesWithStatsForScan), [getAllFiles](#getAllFiles), [filterOnPartitions](#filterOnPartitions), [filterOnPartitions](#filterOnPartitions), [getDataSkippedFiles](#getDataSkippedFiles), [filesForScan](#filesForScan)

### <span id="withStatsInternal"> withStatsInternal DataFrame

```scala
withStatsInternal: DataFrame
```

`withStatsInternal` requests the [withStatsCache](#withStatsCache) for the [DS](../CachedDS.md#getDS).

### <span id="withStatsCache"> withStatsCache

```scala
withStatsCache: CachedDS[Row]
```

??? note "Lazy Value"
    `withStatsCache` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`withStatsCache` [caches](../StateCache.md#cacheDS) the [withStatsInternal0 DataFrame](#withStatsInternal0) under the following name (with the [version](#version) and the [redactedPath](#redactedPath)):

```text
Delta Table State with Stats #[version] - [redactedPath]
```

### <span id="withStatsInternal0"> withStatsInternal0 DataFrame

```scala
withStatsInternal0: DataFrame
```

`withStatsInternal0` is the [allFiles Dataset](#allFiles) with the statistics parsed (the `stats` column decoded from JSON).

## <span id="filesForScan"> filesForScan

??? note "Signature"

    ```scala
    filesForScan(
      limit: Long): DeltaScan
    filesForScan(
      limit: Long,
      partitionFilters: Seq[Expression]): DeltaScan
    filesForScan(
      filters: Seq[Expression],
      keepNumRecords: Boolean): DeltaScan
    ```

    `filesForScan` is part of the [DeltaScanGenerator](DeltaScanGenerator.md#filesForScan) abstraction.

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

### <span id="pruneFilesByLimit"> pruneFilesByLimit

```scala
pruneFilesByLimit(
  df: DataFrame,
  limit: Long): ScanAfterLimit
```

`pruneFilesByLimit`...FIXME

### <span id="getFilesAndNumRecords"> getFilesAndNumRecords

```scala
getFilesAndNumRecords(
  df: DataFrame): Iterator[(AddFile, NumRecords)]
```

`getFilesAndNumRecords`...FIXME

## <span id="columnMappingMode"> Column Mapping Mode

```scala
columnMappingMode: DeltaColumnMappingMode
```

`columnMappingMode` is the value of [columnMapping.mode](../DeltaConfigs.md#COLUMN_MAPPING_MODE) table property (in the [Metadata](#metadata)).

## <span id="getStatsColumnOpt"> getStatsColumnOpt

```scala
getStatsColumnOpt(
  stat: StatsColumn): Option[Column] // (1)!
getStatsColumnOpt(
  statType: String,
  pathToColumn: Seq[String] = Nil): Option[Column]
```

1. Uses `statType` and `pathToColumn` of the given `StatsColumn`

`getStatsColumnOpt` resolves the given `pathToColumn` to a `Column` to access a requested `statType` statistics.

---

`getStatsColumnOpt` looks up the `statType` in the [statistics schema](../StatisticsCollection.md#statsSchema) (by name). If not available, `getStatsColumnOpt` returns `None` (an undefined value) immediately.

`getStatsColumnOpt`...FIXME

`getStatsColumnOpt` filters out non-leaf `StructType` columns as they lack statistics and skipping predicates can't use them.

Due to a JSON truncation of timestamps to milliseconds, for [maxValues](#maxValues) statistic of `TimestampType`s, `getStatsColumnOpt` adjusts 1 millisecond upwards (to include records that differ in microsecond precision).

---

`getStatsColumnOpt` is used when:

* `DataSkippingReaderBase` is requested to [getStatsColumnOrNullLiteral](#getStatsColumnOrNullLiteral) and [getStatsColumnOpt](#getStatsColumnOpt)
* `DataFiltersBuilder` is [created](DataFiltersBuilder.md#statsProvider)

## <span id="getStatsColumnOrNullLiteral"> getStatsColumnOrNullLiteral

```scala
getStatsColumnOrNullLiteral(
  stat: StatsColumn): Column // (1)!
getStatsColumnOrNullLiteral(
  statType: String,
  pathToColumn: Seq[String] = Nil): Column
```

1. Uses `statType` and `pathToColumn` of the given `StatsColumn`

`getStatsColumnOrNullLiteral` [getStatsColumnOpt](#getStatsColumnOpt) (for the `statType` and `pathToColumn`), if available, or falls back to `lit(null)`.

---

`getStatsColumnOrNullLiteral` is used when:

* `DataSkippingReaderBase` is requested to [verifyStatsForFilter](#verifyStatsForFilter), [buildSizeCollectorFilter](#buildSizeCollectorFilter)

## <span id="getDataSkippedFiles"> getDataSkippedFiles

```scala
getDataSkippedFiles(
  partitionFilters: Column,
  dataFilters: DataSkippingPredicate,
  keepNumRecords: Boolean): (Seq[AddFile], Seq[DataSize])
```

`getDataSkippedFiles` [builds the size collectors and the filter functions](#buildSizeCollectorFilter):

 Size Collector | `Column => Column` Filter Function
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

`getDataSkippedFiles` takes the [withStats DataFrame](#withStats) and adds the following `WHERE` clauses (and creates a `filteredFiles` dataset):

1. `totalFilter` with `Literal.TrueLiteral`
1. `partitionFilter` with the given `partitionFilters`
1. `scanFilter` with the given `dataFilters` or a negation of [verifyStatsForFilter](#verifyStatsForFilter) (with the referenced statistics of the `dataFilters`)

!!! note
    At this point, `getDataSkippedFiles` has built a `DataFrame` that is a filtered [withStats DataFrame](#withStats).

With the given `keepNumRecords` flag enabled, `getDataSkippedFiles` adds JSON-encoded `numRecords` column (based on `stats.numRecords` column).

```scala
to_json(struct(col("stats.numRecords") as 'numRecords))
```

??? note "keepNumRecords flag is always disabled"
    The given `keepNumRecords` flag is always off (`false`) per the default value of [filesForScan](DeltaScanGenerator.md#filesForScan).

In the end, `getDataSkippedFiles` [converts the filtered DataFrame to AddFiles](#convertDataFrameToAddFiles) and the `DataSize`s based on the following `ArrayAccumulator`s:

1. `totalSize`
1. `partitionSize`
1. `scanSize`

## <span id="convertDataFrameToAddFiles"> convertDataFrameToAddFiles

```scala
convertDataFrameToAddFiles(
  df: DataFrame): Array[AddFile]
```

`convertDataFrameToAddFiles` converts the given `DataFrame` (a `Dataset[Row]`) to a `Dataset[AddFile]` and executes `Dataset.collect` operator.

!!! note "web UI"
    `Dataset.collect` is an action and can be tracked in web UI.

---

`convertDataFrameToAddFiles` is used when:

* `DataSkippingReaderBase` is requested to [getAllFiles](#getAllFiles), [filterOnPartitions](#filterOnPartitions), [getDataSkippedFiles](#getDataSkippedFiles), [getSpecificFilesWithStats](#getSpecificFilesWithStats)
