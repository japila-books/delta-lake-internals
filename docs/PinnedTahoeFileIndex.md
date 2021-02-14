# PinnedTahoeFileIndex

`PinnedTahoeFileIndex` is a [TahoeFileIndex](TahoeFileIndex.md).

## Creating Instance

`PinnedTahoeFileIndex` takes the following to be created:

* <span id="spark"> `SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession))
* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="path"> Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)
* <span id="snapshot"> [Snapshot](Snapshot.md)

`PinnedTahoeFileIndex` is created when:

* [ActiveOptimisticTransactionRule](ActiveOptimisticTransactionRule.md) logical optimization rule is executed
