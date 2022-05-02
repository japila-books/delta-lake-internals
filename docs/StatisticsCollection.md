# StatisticsCollection

`StatisticsCollection` is an [abstraction](#contract) of [statistics collectors](#implementations).

## Contract

### <span id="dataSchema"> Data Schema

```scala
dataSchema: StructType
```

Used when:

* `StatisticsCollection` is requested for [statCollectionSchema](#statCollectionSchema) and [statsSchema](#statsSchema)

### <span id="numIndexedCols"> numIndexedCols

```scala
numIndexedCols: Int
```

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

## <span id="statsCollector"> statsCollector

```scala
statsCollector: Column
```

`statsCollector`...FIXME

`statsCollector` is used when:

* `OptimisticTransactionImpl` is requested for [statsCollector](OptimisticTransactionImpl.md#statsCollector) (of the table at the snapshot within this transaction)
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
