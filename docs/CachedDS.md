# CachedDS &mdash; Cached Delta State

`CachedDS` is used when [StateCache](StateCache.md) is requested to [cacheDS](#cacheDS).

## Creating Instance

`CachedDS` takes the following to be created:

* <span id="ds"> `Dataset[A]`
* <span id="name"> Name

`CachedDS` is created when:

* `StateCache` is requested to [cacheDS](StateCache.md#cacheDS)

## <span id="cachedDs"> cachedDs

```scala
cachedDs: Option[DatasetRefCache[Row]]
```

!!! note
    `cachedDs` is a value so initialized immediately when `CachedDS` is [created](#creating-instance).

`cachedDs` requests the [Dataset](#ds) for an `RDD[InternalRow]`.

`cachedDs` associates the RDD with the [name](#name) and marks it to be persist (on the first action).

`cachedDs` adds the RDD to the [cached](#cached) registry.

!!! note
    `CachedDS` is an internal class of `StateCache` and has access to its internals.

`cachedDs` is used when:

* `CachedDS` is requested to [getDF](#getDF)

## <span id="getDS"> getDS

```scala
getDS: Dataset[A]
```

`getDS` [gets the cached DataFrame](#getDF) and converts the rows to `A` type.

`getDS` is used when:

* `Snapshot` is requested for the [stateDS Dataset](Snapshot.md#stateDS)
* `DeltaSourceSnapshot` is requested for the [initialFiles Dataset](spark-connector/DeltaSourceSnapshot.md#initialFiles)
* `DataSkippingReaderBase` is requested for the [withStatsInternal Dataset](data-skipping/DataSkippingReaderBase.md#withStatsInternal)
