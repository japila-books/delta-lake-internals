# DeltaSink

DeltaSink is the sink of <<DeltaDataSource.md#, delta data source>> for streaming queries in Spark Structured Streaming.

TIP: Read up on https://jaceklaskowski.gitbooks.io/spark-structured-streaming/spark-sql-streaming-Sink.html[Streaming Sink] in https://bit.ly/spark-structured-streaming[The Internals of Spark Structured Streaming] online book.

DeltaSink is <<creating-instance, created>> exclusively when `DeltaDataSource` is requested for a <<DeltaDataSource.md#createSink, streaming sink>> (Structured Streaming).

[[toString]]
DeltaSink uses the following text representation (with the <<path, path>>):

```
DeltaSink[path]
```

[[ImplicitMetadataOperation]]
DeltaSink is an <<ImplicitMetadataOperation.md#, operation that can update metadata (schema and partitioning)>> of a <<path, delta table>>.

== [[creating-instance]] Creating Instance

DeltaSink takes the following to be created:

* [[sqlContext]] `SQLContext`
* [[path]] Hadoop [Path](https://hadoop.apache.org/docs/r{{ hadoop.version }}/api/org/apache/hadoop/fs/Path.html) of the delta table (to <<addBatch, write data to>> as configured by the [path](options.md#path) option)
* [[partitionColumns]] Names of the partition columns (`Seq[String]`)
* [[outputMode]] `OutputMode`
* [[options]] [DeltaOptions](DeltaOptions.md)

== [[deltaLog]] `deltaLog` Internal Property

[source, scala]
----
deltaLog: DeltaLog
----

`deltaLog` is a <<DeltaLog.md#, DeltaLog>> that is <<DeltaLog.md#forTable, created>> for the <<path, delta table>> when DeltaSink is created (when `DeltaDataSource` is requested for a <<DeltaDataSource.md#createSink, streaming sink>>).

`deltaLog` is used exclusively when DeltaSink is requested to <<addBatch, add a streaming micro-batch>>.

== [[addBatch]] Adding Streaming Micro-Batch

[source, scala]
----
addBatch(
  batchId: Long,
  data: DataFrame): Unit
----

NOTE: `addBatch` is part of the `Sink` contract (in Spark Structured Streaming) to add a batch of data to the sink.

`addBatch` requests the <<deltaLog, DeltaLog>> to <<DeltaLog.md#withNewTransaction, start a new transaction>>.

`addBatch`...FIXME

In the end, `addBatch` requests the `OptimisticTransaction` to <<OptimisticTransactionImpl.md#commit, commit>>.
