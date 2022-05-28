# TahoeBatchFileIndex

`TahoeBatchFileIndex` is a [file index](TahoeFileIndex.md) of a [delta table](#deltaLog) at a given [version](#snapshot).

## Creating Instance

`TahoeBatchFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* [Action Type](#actionType)
* <span id="addFiles"> [AddFile](AddFile.md)s
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="path"> Data directory (as Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html))
* <span id="snapshot"> [Snapshot](Snapshot.md)

`TahoeBatchFileIndex` is created when:

* `DeltaLog` is requested for a [DataFrame for given AddFiles](DeltaLog.md#createDataFrame)
* [DeleteCommand](commands/delete/DeleteCommand.md) and [UpdateCommand](commands/update/UpdateCommand.md) are executed (and `DeltaCommand` is requested for a [HadoopFsRelation](commands/DeltaCommand.md#buildBaseRelation))

## <span id="actionType"> Action Type

`TahoeBatchFileIndex` is given an **Action Type** identifier when [created](#creating-instance):

* **batch** or **streaming** when `DeltaLog` is requested for a batch or streaming [DataFrame for given AddFiles](DeltaLog.md#createDataFrame), respectively
* **delete** for [DeleteCommand](commands/delete/DeleteCommand.md)
* **update** for [UpdateCommand](commands/update/UpdateCommand.md)

!!! important
    Action Type seems not to be used ever.

## <span id="tableVersion"> tableVersion

```scala
tableVersion: Long
```

`tableVersion` is part of the [TahoeFileIndex](TahoeFileIndex.md#tableVersion) abstraction.

`tableVersion` is always the [version](Snapshot.md#version) of the [Snapshot](#snapshot).

## <span id="matchingFiles"> matchingFiles

```scala
matchingFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression],
  keepStats: Boolean = false): Seq[AddFile]
```

`matchingFiles` is part of the [TahoeFileIndex](TahoeFileIndex.md#matchingFiles) abstraction.

`matchingFiles` [filterFileList](DeltaLog.md#filterFileList) (that gives a `DataFrame`) and collects the [AddFile](AddFile.md)s (using `Dataset.collect`).

## <span id="inputFiles"> Input Files

```scala
inputFiles: Array[String]
```

`inputFiles` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/datasources/FileIndex/#inputFiles)) abstraction.

`inputFiles` returns the [paths](AddFile.md#path) of all the given [AddFiles](#addFiles).

## <span id="partitionSchema"> Partitions

```scala
partitionSchema: StructType
```

`partitionSchema` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/datasources/FileIndex/#partitionSchema)) abstraction.

`partitionSchema` requests the [Snapshot](#snapshot) for the [metadata](Snapshot.md#metadata) that is in turn requested for the [partitionSchema](Metadata.md#partitionSchema).

## <span id="sizeInBytes"> Estimated Size of Relation

```scala
sizeInBytes: Long
```

`sizeInBytes` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/datasources/FileIndex/#sizeInBytes)) abstraction.

`sizeInBytes` is a sum of the [sizes](AddFile.md#size) of all the given [AddFiles](#addFiles).
