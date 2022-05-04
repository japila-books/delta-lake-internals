# StatisticsCollection

`StatisticsCollection` is an [abstraction](#contract) of [statistics collectors](#implementations).

## Contract

### <span id="dataSchema"> Data Schema

```scala
dataSchema: StructType
```

Used when:

* `StatisticsCollection` is requested for [statCollectionSchema](#statCollectionSchema) and [statsSchema](#statsSchema)

### <span id="numIndexedCols"> Maximum Number of Indexed Columns

```scala
numIndexedCols: Int
```

Maximum number of leaf columns to collect stats on

Used when:

* `StatisticsCollection` is requested for [statCollectionSchema](#statCollectionSchema) and to [collectStats](#collectStats)

### <span id="spark"> SparkSession

```scala
spark: SparkSession
```

Used when:

* `StatisticsCollection` is requested for [statsCollector](#statsCollector) and [statsSchema](#statsSchema)

## Implementations

* [writeFiles](TransactionalWrite.md#writeFiles)
* [DataSkippingReaderBase](DataSkippingReaderBase.md)
* [Snapshot](Snapshot.md)

## <span id="statsSchema"> statsSchema

```scala
statsSchema: StructType
```

`statsSchema`...FIXME

`statsSchema` is used when:

* `DataSkippingReaderBase` is requested for [getStatsColumnOpt](DataSkippingReaderBase.md#getStatsColumnOpt), [withStatsInternal0](DataSkippingReaderBase.md#withStatsInternal0), [getStatsColumnOpt](DataSkippingReaderBase.md#getStatsColumnOpt)

## <span id="statsCollector"> statsCollector Column

```scala
statsCollector: Column
```

`statsCollector` takes the value of [DeltaSQLConf.DATA_SKIPPING_STRING_PREFIX_LENGTH](DeltaSQLConf.md#DATA_SKIPPING_STRING_PREFIX_LENGTH) configuration property.

`statsCollector` creates a `Column` with `stats` name to be a `struct` of the following:

1. `count(*)` as `numRecords`
1. [collectStats](#collectStats) as `minValues`
1. [collectStats](#collectStats) as `maxValues`
1. [collectStats](#collectStats) as `nullCount`

??? note "Lazy Value"
    `statsCollector` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`statsCollector` is used when:

* `OptimisticTransactionImpl` is requested for the [stats collector column](OptimisticTransactionImpl.md#statsCollector) (of the table at the snapshot within this transaction)
* `TransactionalWrite` is requested to [writeFiles](TransactionalWrite.md#writeFiles)
* `StatisticsCollection` is requested for [statsSchema](#statsSchema)

### <span id="collectStats"> collectStats

```scala
collectStats(
  name: String,
  schema: StructType)(
  function: PartialFunction[(Column, StructField), Column]): Column
```

`collectStats`...FIXME

### <span id="statCollectionSchema"> statCollectionSchema

```scala
statCollectionSchema: StructType
```

For the [number of leaf columns to collect stats on](#numIndexedCols) greater than or equal `0`, `statCollectionSchema` [truncate](#truncateSchema) the [dataSchema](#dataSchema). Otherwise, `statCollectionSchema` returns the [dataSchema](#dataSchema) intact.

??? note "Lazy Value"
    `statCollectionSchema` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

### <span id="truncateSchema"> truncateSchema

```scala
truncateSchema(
  schema: StructType,
  indexedCols: Int): (StructType, Int)
```

`truncateSchema`...FIXME
