---
hide:
  - toc
---

# {{ book.title }}

[Delta Lake](https://delta.io/) is an open-source [Apache Spark](https://spark.apache.org/)-based storage layer that brings ACID transactions and time travel to Spark and other big data workloads.

As [it was well said](https://github.com/delta-io/delta/issues/467#issuecomment-696708455): _"Delta is a storage format while Spark is an execution engine...to separate storage from compute."_

!!! important
    As of 0.7.0 Delta Lake requires Spark 3. Please note that [Spark 3.1.1 is not yet supported](https://github.com/delta-io/delta/issues/594). Use Spark 3.0.2 instead.

Delta Lake is a table format. It introduces [DeltaTable](DeltaTable.md) abstraction that is simply a [parquet table](DeltaFileFormat.md#fileFormat) with a [transactional log](DeltaLog.md).

Changes to (the state of) a delta table are reflected as [actions](Action.md) and persisted to the transactional log (in [JSON format](Action.md#json)).

Delta Lake uses [OptimisticTransaction](OptimisticTransaction.md) for [transactional writes](TransactionalWrite.md). A [commit](OptimisticTransactionImpl.md#commit) is successful when the transaction can [write](OptimisticTransactionImpl.md#doCommit-write) the actions to a delta file (in the [transactional log](DeltaLog.md)). In case the delta file for the commit version already exists, the transaction is [retried](OptimisticTransactionImpl.md#checkAndRetry).

Structured queries can write (transactionally) to a delta table using the following interfaces:

* [WriteIntoDelta](commands/WriteIntoDelta.md) command for batch queries (Spark SQL)

* [DeltaSink](DeltaSink.md) for streaming queries (Spark Structured Streaming)

More importantly, multiple queries can write to the same delta table simultaneously (at exactly the same time).

Delta Lake provides [DeltaTable API](DeltaTable.md) to programmatically access Delta tables. A delta table can be created [based on a parquet table](DeltaTable.md#convertToDelta) or [from scratch](DeltaTable.md#forPath).

Delta Lake supports batch and streaming queries (Spark SQL and Structured Streaming, respectively) using [delta](DeltaDataSource.md#DataSourceRegister) format.

In order to fine tune queries over data in Delta Lake use [options](options.md). Among the options [path](options.md#path) option is mandatory.

Delta Lake supports reading and writing in batch queries:

* [Batch reads](DeltaDataSource.md#RelationProvider) (as a `RelationProvider`)

* [Batch writes](DeltaDataSource.md#CreatableRelationProvider) (as a `CreatableRelationProvider`)

Delta Lake supports reading and writing in streaming queries:

* [Stream reads](DeltaDataSource.md#StreamSourceProvider) (as a `Source`)

* [Stream writes](DeltaDataSource.md#StreamSinkProvider) (as a `Sink`)

Delta Lake uses [LogStore](DeltaLog.md#store) abstraction to read and write physical log files and checkpoints (using [Hadoop FileSystem API]({{ hadoop.docs }}/hadoop-project-dist/hadoop-common/filesystem/index.html)).

## Delta Tables in Logical Query Plans

Delta Table defines `DeltaTable` Scala extractor to find delta tables in a logical query plan. The extractor finds `LogicalRelation`s ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation)) with `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) and [TahoeFileIndex](TahoeFileIndex.md).

Put simply, delta tables are `LogicalRelation`s with `HadoopFsRelation` with [TahoeFileIndex](TahoeFileIndex.md) in logical query plans.

## Concurrent Blind Append Transactions

A [transaction](OptimisticTransaction.md) can be [blind append](OptimisticTransactionImpl.md#commit-isBlindAppend) when simply appends new data to a table with no reliance on existing data (and without reading or modifying it).

They are marked in the [commit info](CommitInfo.md#isBlindAppend) to distinguish them from read-modify-appends (deletes, merges or updates) and assume no conflict between concurrent transactions.

Blind Append Transactions allow for concurrent updates.

```scala
df.format("delta").mode("append").save(...)
```
