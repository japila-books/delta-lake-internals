# StateCache

`StateCache` is an [abstraction](#contract) of [state caches](#implementations) that can [cache a Dataset](#cacheDS) and [uncache them all](#uncache).

## Contract

### <span id="spark"> SparkSession

```scala
spark: SparkSession
```

`SparkSession` the [cached RDDs](#cached) belong to

## Implementations

* [DeltaSourceSnapshot](DeltaSourceSnapshot.md)
* [Snapshot](Snapshot.md)

## <span id="cached"> Cached RDDs

```scala
cached: ArrayBuffer[RDD[_]]
```

`StateCache` tracks cached RDDs in `cached` internal registry.

`cached` is given a new `RDD` when `StateCache` is requested to [cache a Dataset](#cacheDS).

`cached` is used when `StateCache` is requested to [get a cached Dataset](#getDS) and [uncache](#uncache).

## <span id="cacheDS"> Caching Dataset

```scala
cacheDS[A](
  ds: Dataset[A],
  name: String): CachedDS[A]
```

`cacheDS` creates a new [CachedDS](CachedDS.md).

`cacheDS` is used when:

* `Snapshot` is requested for the [cachedState](Snapshot.md#cachedState)
* `DeltaSourceSnapshot` is requested for the [initialFiles](DeltaSourceSnapshot.md#initialFiles)
* `DataSkippingReaderBase` is requested for the [withStatsCache](data-skipping/DataSkippingReaderBase.md#withStatsCache)

## <span id="uncache"> Uncaching All Cached Datasets

```scala
uncache[A](
  ds: Dataset[A],
  name: String): CachedDS[A]
```

`uncache` uses the [isCached](#isCached) internal flag to avoid multiple executions.

`uncache` is used when:

* `DeltaLog` utility is used to access [deltaLogCache](DeltaLog.md#deltaLogCache) and a cached entry expires
* `SnapshotManagement` is requested to [update state of a Delta table](SnapshotManagement.md#updateInternal)
* `DeltaSourceSnapshot` is requested to [close](DeltaSourceSnapshot.md#close)
