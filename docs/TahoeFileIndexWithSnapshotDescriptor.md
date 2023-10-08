# TahoeFileIndexWithSnapshotDescriptor

`TahoeFileIndexWithSnapshotDescriptor` is an extension of the [TahoeFileIndex](TahoeFileIndex.md) abstraction for [file indices](#implementations) with an extra [SnapshotDescriptor](#snapshot).

`TahoeFileIndexWithSnapshotDescriptor` uses the [SnapshotDescriptor](#snapshot) (given when [created](#creating-instance)) to meet the [contract](TahoeFileIndex.md#contract).

## Implementations

* [PreparedDeltaFileIndex](data-skipping/PreparedDeltaFileIndex.md)
* [TahoeBatchFileIndex](TahoeBatchFileIndex.md)
* [TahoeChangeFileIndex](change-data-feed/TahoeChangeFileIndex.md)
* [TahoeRemoveFileIndex](change-data-feed/TahoeRemoveFileIndex.md)

## Creating Instance

`TahoeFileIndexWithSnapshotDescriptor` takes the following to be created:

* <span id="spark"> [SparkSession](TahoeFileIndex.md#spark)
* <span id="deltaLog"> [DeltaLog](TahoeFileIndex.md#deltaLog)
* <span id="path"> [Path](TahoeFileIndex.md#path)
* <span id="snapshot"> [SnapshotDescriptor](SnapshotDescriptor.md)

!!! note "Abstract Class"
    `TahoeFileIndexWithSnapshotDescriptor` is an abstract class and cannot be created directly. It is created indirectly for the [concrete TahoeFileIndexWithSnapshotDescriptors](#implementations).
