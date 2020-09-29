# CachedDS &mdash; Cached Delta State

`CachedDS` is used when [StateCache](StateCache.md) is requested to [cacheDS](#cacheDS).

<span id="cachedDs">
When created, `CachedDS` immediately initializes the `cachedDs` internal registry that requests the [Dataset](#ds) to generate a `RDD[InternalRow]` and associates the RDD with the given [name](#name):

* **Delta Table State** for [Snapshot](Snapshot.md)
* **Delta Source Snapshot** for [DeltaSourceSnapshot](DeltaSourceSnapshot.md)

The RDD is marked to be persisted using `StorageLevel.MEMORY_AND_DISK_SER` storage level.

!!! note
    `CachedDS` is an internal class of `StateCache` and has access to its internals.

## Creating Instance

`CachedDS` takes the following to be created:

* <span id="ds"> `Dataset[A]`
* <span id="name"> Name

`CachedDS` is created when `StateCache` is requested to [cacheDS](#cacheDS).

## <span id="getDS"> getDS Method

```scala
getDS: Dataset[A]
```

`getDS`...FIXME

`getDS` is used when:

* `Snapshot` is requested to [state](Snapshot.md#state)
* `DeltaSourceSnapshot` is requested to [initialFiles](DeltaSourceSnapshot.md#initialFiles)
