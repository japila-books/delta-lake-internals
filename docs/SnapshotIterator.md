# SnapshotIterator

`SnapshotIterator` is an abstraction of [iterators](#implementations) over indexed [AddFile](AddFile.md) actions in a Delta log for [DeltaSourceSnapshot](DeltaSourceSnapshot.md)s.

## <span id="iterator"><span id="result"> Iterator of Indexed AddFiles

```scala
iterator(): Iterator[IndexedFile]
```

`iterator` returns an `Iterator` ([Scala]({{ scala.api }}/scala/collection/Iterator.html)) of `IndexedFile`s ([AddFile](AddFile.md) actions in a Delta log with extra metadata) of [filterFileList](DeltaLog.md#filterFileList).

`iterator` is used when:

* `DeltaSource` is requested for the [snapshot of a delta table at a given version](DeltaSource.md#getSnapshotAt)

## <span id="close"> Closing Iterator (Cleaning Up Internal Resources)

```scala
close(
  unpersistSnapshot: Boolean): Unit
```

`close` is a no-op (and leaves proper operation to [implementations](#implementations)).

`close` is used when:

* `DeltaSource` is requested to [cleanUpSnapshotResources](DeltaSource.md#cleanUpSnapshotResources)

## Implementations

* [DeltaSourceSnapshot](DeltaSourceSnapshot.md)
