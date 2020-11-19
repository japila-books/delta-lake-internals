# TahoeFileIndex

`TahoeFileIndex` is an [extension](#contract) of the `FileIndex` abstraction ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/FileIndex/)) for [file indices](#implementations) of delta tables that can [list data files](#listFiles) to scan (based on [partition and data filters](#matchingFiles)).

The aim of `TahoeFileIndex` (and `FileIndex` in general) is to reduce usage of very expensive disk access for file-related information using Hadoop [FileSystem]({{ hadoop.api }}/org/apache/hadoop/fs/FileSystem.html) API.

## Contract

### <span id="matchingFiles"> matchingFiles

```scala
matchingFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[AddFile]
```

[AddFile](AddFile.md)s matching given partition and data filters (predicates)

Used for [listing data files](#listFiles)

## Implementations

* [TahoeBatchFileIndex](TahoeBatchFileIndex.md)
* [TahoeLogFileIndex](TahoeLogFileIndex.md)

## Creating Instance

`TahoeFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession`
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="path"> Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)

??? note "Abstract Class"
    `TahoeFileIndex` is an abstract class and cannot be created directly. It is created indirectly for the [concrete TahoeFileIndexes](#implementations).

## <span id="rootPaths"> Root Paths

```scala
rootPaths: Seq[Path]
```

`rootPaths` is the [path](#path) only.

`rootPaths` is part of the `FileIndex` abstraction ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/FileIndex/#rootPaths)).

## <span id="listFiles"> Listing Files

```scala
listFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[PartitionDirectory]
```

`listFiles` is the [path](#path) only.

`listFiles` is part of the `FileIndex` abstraction ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/FileIndex/#listFiles)).

## <span id="partitionSchema"> Partitions

```scala
partitionSchema: StructType
```

`partitionSchema` is the [partition schema](Metadata.md#partitionSchema) of (the [Metadata](Snapshot.md#metadata) of the [Snapshot](DeltaLog.md#snapshot)) of the [DeltaLog](#deltaLog).

`partitionSchema` is part of the `FileIndex` abstraction ([Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book/FileIndex/#partitionSchema)).

## <span id="tableVersion"> Version of Delta Table

```scala
tableVersion: Long
```

`tableVersion` is the [version](Snapshot.md#version) of (the [snapshot](DeltaLog.md#snapshot) of) the [DeltaLog](#deltaLog).

`tableVersion` is used when `TahoeFileIndex` is requested for the [human-friendly textual representation](#toString).

## <span id="toString"> Textual Representation

```scala
toString: String
```

`toString` returns the following text (using the [version](tableVersion) and the [path](#path) of the Delta table):

```text
Delta[version=[tableVersion], [truncatedPath]]
```

 `toString` is part of the `java.lang.Object` contract for a string representation of the object.
