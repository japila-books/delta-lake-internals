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

`addBatch` requests the [DeltaLog](#deltaLog) to [start a new transaction](DeltaLog.md#withNewTransaction).

`addBatch` registers the following performance metrics.

Name              | web UI
------------------|------------------------
`numAddedFiles`   | number of files added.
`numRemovedFiles` | number of files removed.

`addBatch` makes sure that `sql.streaming.queryId` local property is defined (attached to the query's current thread).

If the batch reads the same delta table as this sink is going to write to, `addBatch` requests the `OptimisticTransaction` to [readWholeTable](OptimisticTransactionImpl.md#readWholeTable).

`addBatch` [updates the metadata](ImplicitMetadataOperation.md#updateMetadata).

`addBatch` determines the deleted files based on the [OutputMode](#outputMode). For `Complete` output mode, `addBatch`...FIXME

`addBatch` requests the `OptimisticTransaction` to [write data out](TransactionalWrite.md#writeFiles).

`addBatch` updates the `numRemovedFiles` and `numAddedFiles` performance metrics, and requests the `OptimisticTransaction` to [register the SQLMetrics](SQLMetricsReporting.md#registerSQLMetrics).

In the end, `addBatch` requests the `OptimisticTransaction` to [commit](OptimisticTransactionImpl.md#commit) (with a new [SetTransaction](SetTransaction.md), [AddFile](AddFile.md)s and [RemoveFile](RemoveFile.md)s, and [StreamingUpdate](Operation.md#StreamingUpdate) operation).

---

`addBatch` is part of the `Sink` ([Spark Structured Streaming]({{ book.structured_streaming }}/Sink#addBatch)) abstraction.

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
