# DeltaSink

`DeltaSink` is the `Sink` ([Spark Structured Streaming]({{ book.structured_streaming }}/Sink)) of the [delta](DeltaDataSource.md) data source for streaming queries.

## Creating Instance

`DeltaSink` takes the following to be created:

* <span id="sqlContext"> `SQLContext`
* <span id="path"> Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) of the delta table (to [write data to](#addBatch) as configured by the [path](options.md#path) option)
* <span id="partitionColumns"> Names of the partition columns
* <span id="outputMode"> `OutputMode` ([Spark Structured Streaming]({{ book.structured_streaming }}/OutputMode))
* <span id="options"> [DeltaOptions](DeltaOptions.md)

`DeltaSink` is created when:

* `DeltaDataSource` is requested for a [streaming sink](DeltaDataSource.md#createSink)

## <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

`deltaLog` is a [DeltaLog](DeltaLog.md) that is [created](DeltaLog.md#forTable) for the [delta table](#path) when `DeltaSink` is [created](#creating-instance).

`deltaLog` is used when:

* DeltaSink is requested to [add a streaming micro-batch](#addBatch)

## <span id="addBatch"> Adding Streaming Micro-Batch

```scala
addBatch(
  batchId: Long,
  data: DataFrame): Unit
```

`addBatch` is part of the `Sink` ([Spark Structured Streaming]({{ book.structured_streaming }}/Sink#addBatch)) abstraction.

`addBatch` requests the [DeltaLog](#deltaLog) to [start a new transaction](DeltaLog.md#withNewTransaction).

`addBatch`...FIXME

In the end, `addBatch` requests the `OptimisticTransaction` to [commit](OptimisticTransactionImpl.md#commit).

## <span id="toString"> Text Representation

```scala
toString(): String
```

`DeltaSink` uses the following text representation (with the [path](#path)):

```text
DeltaSink[path]
```

## <span id="ImplicitMetadataOperation"> ImplicitMetadataOperation

`DeltaSink` is an [ImplicitMetadataOperation](ImplicitMetadataOperation.md).
