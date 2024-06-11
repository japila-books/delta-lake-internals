# DeletionVectorStoredBitmap

`DeletionVectorStoredBitmap` is a [StoredBitmap](StoredBitmap.md).

## Creating Instance

`DeletionVectorStoredBitmap` takes the following to be created:

* <span id="dvDescriptor"> [DeletionVectorDescriptor](DeletionVectorDescriptor.md)
* [Table Data Path](#tableDataPath)

`DeletionVectorStoredBitmap` is created when:

* `StoredBitmap` is requested to [create a StoredBitmap](StoredBitmap.md#create), [EMPTY](StoredBitmap.md#EMPTY), [inline](StoredBitmap.md#inline)

### Table Data Path { #tableDataPath }

```scala
tableDataPath: Option[Path]
```

`DeletionVectorStoredBitmap` can be given the path to the data directory of a delta table. The path is undefined (`None`) by default.

The path is specified only when `StoredBitmap` utility is requested to [create a StoredBitmap](StoredBitmap.md#create) for [on-disk deletion vectors](DeletionVectorDescriptor.md#isOnDisk).
