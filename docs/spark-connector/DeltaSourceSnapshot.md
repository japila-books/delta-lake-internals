# DeltaSourceSnapshot

`DeltaSourceSnapshot` is a [SnapshotIterator](SnapshotIterator.md) and a [StateCache](../StateCache.md) for [DeltaSource](DeltaSource.md#initialState).

## Creating Instance

`DeltaSourceSnapshot` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="snapshot"> [Snapshot](../Snapshot.md)
* <span id="filters"> Filter Expressions ([Spark SQL]({{ book.spark_sql }}/expressions/Expression))

`DeltaSourceSnapshot` is created when:

* `DeltaSource` is requested for the [snapshot of a delta table at a given version](DeltaSource.md#getSnapshotAt)

## <span id="initialFiles"> initialFiles Dataset (of IndexedFiles)

```scala
initialFiles: Dataset[IndexedFile]
```

### <span id="initialFiles-Dataset-IndexedFile"> Dataset of Indexed AddFiles

`initialFiles` requests the [Snapshot](#snapshot) for [all AddFiles (in the snapshot)](../Snapshot.md#allFiles) (`Dataset[AddFile]`).

`initialFiles` sorts the [AddFile](../AddFile.md) dataset (`Dataset[AddFile]`) by [modificationTime](../AddFile.md#modificationTime) and [path](../AddFile.md#path) in ascending order.

`initialFiles` indexes the `AddFiles` (using `RDD.zipWithIndex` operator) that gives a `RDD[(AddFile, Long)]`.

`initialFiles` converts the `RDD` to a `DataFrame` of two columns: `add` and `index`.

`initialFiles` adds the two new columns:

* [version](#version)
* `isLast` as `false` literal

`initialFiles` converts (_projects_) `DataFrame` to `Dataset[IndexedFile]`.

### <span id="initialFiles-cacheDS"> Creating CachedDS

`initialFiles` [caches](../StateCache.md#cacheDS) the `Dataset[IndexedFile]` under the following name (with the [version](#version) and the [redactedPath](../Snapshot.md#redactedPath) of this [Snapshot](#snapshot)):

```text
Delta Source Snapshot #[version] - [redactedPath]
```

### <span id="initialFiles-getDS"> Cached Dataset of Indexed AddFiles

In the end, `initialFiles` requests the [CachedDS](#initialFiles-cacheDS) to [getDS](../CachedDS.md#getDS).

### <span id="initialFiles-usage"> Usage

`initialFiles` is used when:

* `SnapshotIterator` is requested for the [AddFiles](SnapshotIterator.md#iterator)

## <span id="close"> Closing

```scala
close(
  unpersistSnapshot: Boolean): Unit
```

`close` is part of the [SnapshotIterator](SnapshotIterator.md#close) abstraction.

`close` requests the [Snapshot](#snapshot) to [uncache](../StateCache.md#uncache) when the given `unpersistSnapshot` flag is enabled.
