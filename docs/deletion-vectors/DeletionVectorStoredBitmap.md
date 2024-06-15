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

## Loading Deletion Vector { #load }

??? note "StoredBitmap"

    ```scala
    load(
      dvStore: DeletionVectorStore): RoaringBitmapArray
    ```

    `load` is part of the [StoredBitmap](StoredBitmap.md#load) abstraction.

`load`...FIXME

### Absolute Path of On-Disk Deletion Vector { #onDiskPath }

```scala
onDiskPath: Option[Path]
```

??? note "Lazy Value"
    `onDiskPath` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

If this [tableDataPath](#tableDataPath) is specified, `onDiskPath` is converted to an [absolute path](DeletionVectorDescriptor.md#tableDataPath). Otherwise, `onDiskPath` is undefined (`None`).
