# {{ book.title }}

[Delta Lake](https://delta.io/) is an open-source table format (storage layer) for cloud data lakes with [ACID transactions](../OptimisticTransaction.md), [time travel](../time-travel/index.md) and many many more that make it so amazing (even _[awesomesauce](https://dictionary.cambridge.org/dictionary/english/awesomesauce)_ 😏):

* [Auto Compaction](../auto-compaction/index.md)
* [Change Data Feed](../change-data-feed/index.md)
* [CHECK Constraints](../check-constraints/index.md)
* [Column Invariants](../column-invariants/index.md)
* [Column Mapping](../column-mapping/index.md)
* [Column Statistics](../column-statistics/index.md)
* [Commands](../commands/index.md)
* [Data Skipping](../data-skipping/index.md)
* [Deletion Vectors](../deletion-vectors/index.md)
* [Delta SQL](../sql/index.md)
* [Developer API](../DeltaTable.md)
* [Generated Columns](../generated-columns/index.md)
* [Spark SQL integration with support for batch and streaming queries](../spark-connector/DeltaDataSource.md)
* [Table Constraints](../constraints/index.md)
* [Time Travel](../time-travel/index.md)
* _others_ (listed in the menu on the left)

Delta Lake allows you to store data on blob stores like HDFS, S3, Azure Data Lake, GCS, query from many processing engines including Apache Spark, Trino, Apache Hive, Apache Flink, and provides APIs for SQL, Scala, Java, Python, Rust (to name a few).

As [it was well said]({{ delta.issues }}/467#issuecomment-696708455): _"Delta is a storage format while Spark is an execution engine...to separate storage from compute."_
Delta Lake can run with other execution engines like [Trino](https://trino.io/docs/current/connector/delta-lake.html) or [Apache Flink](https://github.com/delta-io/connectors/tree/master/flink).

Delta tables can be registered in a table catalog. Delta Lake creates a transaction log at the root directory of a table, and the catalog contains no information but the table format and the location of the table. All table properties, schema and partitioning information live in the transaction log to avoid a "split brain" situation ([Wikipedia](https://en.wikipedia.org/wiki/Split-brain_(computing))).

Delta Lake {{ delta.version }} supports Apache Spark {{ spark.version }} (cf. [build.sbt]({{ delta.github }}/build.sbt#L37)).

## Delta Tables

Delta tables are [parquet table](../DeltaFileFormat.md#fileFormat)s with a [transactional log](../DeltaLog.md).

Changes to (the state of) a delta table are reflected as [actions](../Action.md) and persisted to the transactional log (in [JSON format](../Action.md#json)).

## OptimisticTransaction

Delta Lake uses [OptimisticTransaction](../OptimisticTransaction.md) for [transactional writes](../TransactionalWrite.md). A [commit](../OptimisticTransactionImpl.md#commit) is successful when the transaction can [write](../OptimisticTransactionImpl.md#doCommit-write) the actions to a delta file (in the [transactional log](../DeltaLog.md)). In case the delta file for the commit version already exists, the transaction is [retried](../OptimisticTransactionImpl.md#checkAndRetry).

More importantly, multiple queries can write to the same delta table simultaneously (at exactly the same time).

## Transactional Writers

[TransactionalWrite](../TransactionalWrite.md) is an interface for writing out data to a delta table.

The following commands and interfaces can [transactionally write new data files out](../TransactionalWrite.md#writeFiles-usage) to a data directory of a delta table:

* [Delete](../commands/delete/index.md)
* [DeltaSink](../spark-connector/DeltaSink.md#addBatch)
* [Merge](../commands/merge/index.md)
* [Optimize](../commands/optimize/index.md)
* [Update](../commands/update/index.md)
* [WriteIntoDelta](../commands/WriteIntoDelta.md)

## Developer APIs

Delta Lake provides the following [Developer APIs](../developer-api.md) for developers to interact with (and even extend) Delta Lake using a supported programming language:

* [DeltaTable](../DeltaTable.md)
* [DeltaTableBuilder](../DeltaTableBuilder.md)
* [DeltaColumnBuilder](../DeltaColumnBuilder.md)

## Structured Queries

Delta Lake supports batch and streaming queries (Spark SQL and Structured Streaming, respectively) using [delta](../spark-connector/DeltaDataSource.md#DataSourceRegister) format.

In order to fine tune queries over data in Delta Lake use [options](../spark-connector/options.md).

Structured queries can write (transactionally) to a delta table using the following interfaces:

* [WriteIntoDelta](../commands/WriteIntoDelta.md) command for batch queries (Spark SQL)
* [DeltaSink](../spark-connector/DeltaSink.md) for streaming queries (Spark Structured Streaming)

### Batch Queries

Delta Lake supports reading and writing in batch queries:

* [Batch reads](../spark-connector/DeltaDataSource.md#RelationProvider) (as a `RelationProvider`)

* [Batch writes](../spark-connector/DeltaDataSource.md#CreatableRelationProvider) (as a `CreatableRelationProvider`)

### Streaming Queries

Delta Lake supports reading and writing in streaming queries:

* [Stream reads](../spark-connector/DeltaDataSource.md#StreamSourceProvider) (as a `Source`)

* [Stream writes](../spark-connector/DeltaDataSource.md#StreamSinkProvider) (as a `Sink`)

## LogStore

Delta Lake uses [LogStore](../storage/LogStore.md) abstraction for reading and writing physical log files and checkpoints (using [Hadoop FileSystem API]({{ hadoop.docs }}/hadoop-project-dist/hadoop-common/filesystem/index.html)).

## Delta Tables in Logical Query Plans

Delta Table defines `DeltaTable` Scala extractor to find delta tables in a logical query plan. The extractor finds `LogicalRelation`s ([Spark SQL]({{ book.spark_sql }}/logical-operators/LogicalRelation)) with `HadoopFsRelation` ([Spark SQL]({{ book.spark_sql }}/HadoopFsRelation)) and [TahoeFileIndex](../TahoeFileIndex.md).

Put simply, delta tables are `LogicalRelation`s with `HadoopFsRelation` with [TahoeFileIndex](../TahoeFileIndex.md) in logical query plans.

## Concurrent Blind Append Transactions

A [transaction](../OptimisticTransaction.md) can be [blind append](../OptimisticTransactionImpl.md#commit-isBlindAppend) when simply appends new data to a table with no reliance on existing data (and without reading or modifying it).

Blind append transactions are marked in the [commit info](../CommitInfo.md#isBlindAppend) to distinguish them from read-modify-appends (deletes, merges or updates) and assume no conflict between concurrent transactions.

Blind Append Transactions allow for concurrent updates.

```scala
df.format("delta")
  .mode("append")
  .save(...)
```

## Exception Public API

Delta Lake introduces [exceptions](../exceptions/index.md) due to conflicts between concurrent operations as a public API.

## Learn More

1. [What's New in Delta Lake 2.3.0](https://www.linkedin.com/posts/willgirten_delta-lake-230-was-released-last-week-and-ugcPost-7051596576711925760-wvff/) by Will Girten
