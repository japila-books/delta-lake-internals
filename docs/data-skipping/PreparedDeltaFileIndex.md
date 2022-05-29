# PreparedDeltaFileIndex

`PreparedDeltaFileIndex` is a [TahoeFileIndex](../TahoeFileIndex.md) that uses [DeltaScan](#preparedScan) for all the work.

## Creating Instance

`PreparedDeltaFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="deltaLog"> [DeltaLog](../DeltaLog.md)
* <span id="path"> Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)
* [DeltaScan](#preparedScan)
* <span id="partitionSchema"> Partition schema ([StructType]({{ book.spark_sql }}/types/StructType))
* <span id="versionScanned"> Version scanned

`PreparedDeltaFileIndex` is created when:

* `PrepareDeltaScanBase` logical optimization rule is [executed](PrepareDeltaScanBase.md#getPreparedIndex)

## <span id="preparedScan"> DeltaScan

`PreparedDeltaFileIndex` is given a [DeltaScan](DeltaScan.md) when [created](#creating-instance).

The `DeltaScan` is used for all its methods.

## <span id="inputFiles"> Input Files

```scala
inputFiles: Array[String]
```

`inputFiles`...FIXME

`inputFiles` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/datasources/FileIndex#inputFiles)) abstraction.

## <span id="matchingFiles"> Matching Data Files

```scala
matchingFiles(
  partitionFilters: Seq[Expression],
  dataFilters: Seq[Expression]): Seq[AddFile]
```

`matchingFiles`...FIXME

`matchingFiles` is part of the [TahoeFileIndex](../TahoeFileIndex.md#matchingFiles) abstraction.

## <span id="sizeInBytes"> Estimated Size

```scala
sizeInBytes: Long
```

`sizeInBytes`...FIXME

`sizeInBytes` is part of the `FileIndex` ([Spark SQL]({{ book.spark_sql }}/datasources/FileIndex#sizeInBytes)) abstraction.
