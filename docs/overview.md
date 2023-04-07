# {{ book.title }}

[Delta Lake](https://delta.io/) is an open-source table format (storage layer) for cloud data lakes with [ACID transactions](OptimisticTransaction.md), [time travel](time-travel/index.md) and [many more](features/index.md) (you'd rather not wanna miss in your data-heavy architectures).

Delta Lake allows you to store data on blob stores like HDFS, S3, Azure Data Lake, GCS, query from many processing engines including Apache Spark, Trino, Apache Hive, Apache Flink, and provides APIs for Scala, Java, Python, Rust, and Ruby.

As [it was well said](https://github.com/delta-io/delta/issues/467#issuecomment-696708455): _"Delta is a storage format while Spark is an execution engine...to separate storage from compute."_ Yet, Delta Lake can run with other execution engines like [Trino](https://trino.io/docs/current/connector/delta-lake.html) or [Apache Flink](https://github.com/delta-io/connectors/tree/master/flink).

Delta Lake {{ delta.version }} supports Apache Spark {{ spark.version }} (cf. [build.sbt]({{ delta.github }}/build.sbt#L20)).

## Delta Tables

Delta tables are [parquet table](DeltaFileFormat.md#fileFormat)s with a [transactional log](DeltaLog.md).

Changes to (the state of) a delta table are reflected as [actions](Action.md) and persisted to the transactional log (in [JSON format](Action.md#json)).

## OptimisticTransaction

Delta Lake uses [OptimisticTransaction](OptimisticTransaction.md) for [transactional writes](TransactionalWrite.md). A [commit](OptimisticTransactionImpl.md#commit) is successful when the transaction can [write](OptimisticTransactionImpl.md#doCommit-write) the actions to a delta file (in the [transactional log](DeltaLog.md)). In case the delta file for the commit version already exists, the transaction is [retried](OptimisticTransactionImpl.md#checkAndRetry).

More importantly, multiple queries can write to the same delta table simultaneously (at exactly the same time).

## Transactional Writers

[TransactionalWrite](TransactionalWrite.md) is an interface for writing out data to a delta table.

The following commands and operations can [transactionally write new data files out](TransactionalWrite.md#writeFiles-usage) to a data directory of a delta table:

* [DeleteCommand](commands/delete/DeleteCommand.md)
* [MergeIntoCommand](commands/merge/MergeIntoCommand.md)
* [OptimizeTableCommand](./commands/optimize/OptimizeTableCommand.md)
* [UpdateCommand](commands/update/UpdateCommand.md)
* [WriteIntoDelta](commands/WriteIntoDelta.md)
* [DeltaSink](delta/DeltaSink.md#addBatch)

## Developer APIs

Delta Lake provides the following [Developer APIs](developer-api.md) for developers to interact with (and even extend) Delta Lake using a supported programming language:

* [DeltaTable](DeltaTable.md)
* [DeltaTableBuilder](DeltaTableBuilder.md)
* [DeltaColumnBuilder](DeltaColumnBuilder.md)

## Structured Queries

Delta Lake supports batch and streaming queries (Spark SQL and Structured Streaming, respectively) using [delta](delta/DeltaDataSource.md#DataSourceRegister) format.

In order to fine tune queries over data in Delta Lake use [options](delta/options.md).

Structured queries can write (transactionally) to a delta table using the following interfaces:

* [WriteIntoDelta](commands/WriteIntoDelta.md) command for batch queries (Spark SQL)
* [DeltaSink](delta/DeltaSink.md) for streaming queries (Spark Structured Streaming)

### Batch Queries

Delta Lake supports reading and writing in batch queries:

* [Batch reads](delta/DeltaDataSource.md#RelationProvider) (as a `RelationProvider`)

* [Batch writes](delta/DeltaDataSource.md#CreatableRelationProvider) (as a `CreatableRelationProvider`)

### Streaming Queries

Delta Lake supports reading and writing in streaming queries:

* [Stream reads](delta/DeltaDataSource.md#StreamSourceProvider) (as a `Source`)

* [Stream writes](delta/DeltaDataSource.md#StreamSinkProvider) (as a `Sink`)

## LogStore

Delta Lake uses [LogStore](storage/LogStore.md) abstraction for reading and writing physical log files and checkpoints (using [Hadoop FileSystem API]({{ hadoop.docs }}/hadoop-project-dist/hadoop-common/filesystem/index.html)).

## Delta Tables in Logical Query Plans

Delta Table defines `DeltaTable` Scala extractor to find delta tables in a logical query plan. The extractor finds `LogicalRelation`s ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation)) with `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) and [TahoeFileIndex](TahoeFileIndex.md).

Put simply, delta tables are `LogicalRelation`s with `HadoopFsRelation` with [TahoeFileIndex](TahoeFileIndex.md) in logical query plans.

## Concurrent Blind Append Transactions

A [transaction](OptimisticTransaction.md) can be [blind append](OptimisticTransactionImpl.md#commit-isBlindAppend) when simply appends new data to a table with no reliance on existing data (and without reading or modifying it).

Blind append transactions are marked in the [commit info](CommitInfo.md#isBlindAppend) to distinguish them from read-modify-appends (deletes, merges or updates) and assume no conflict between concurrent transactions.

Blind Append Transactions allow for concurrent updates.

```scala
df.format("delta")
  .mode("append")
  .save(...)
```

## Generated Columns

Delta Lake supports [Generated Columns](generated-columns/index.md).

## Table Constraints

Delta Lake introduces [table constraints](constraints/index.md) to ensure data quality and integrity (during writes).

## Exception Public API

Delta Lake introduces [exceptions](exceptions/index.md) due to conflicts between concurrent operations as a public API.

## Simplified Storage Configuration

[Storage](storage/index.md)
