# Overview

[Delta Lake](https://delta.io/) is an open-source storage management system (storage layer) that brings ACID transactions and time travel to [Apache Spark](https://spark.apache.org/) and big data workloads.

!!! important
    As of 0.7.0 Delta Lake requires Spark 3 (starting from the first [3.0.0](http://spark.apache.org/news/spark-3-0-0-released.html) release).

Delta Lake introduces a concept of [DeltaTable](DeltaTable.md) that is simply a [parquet table](DeltaFileFormat.md#fileFormat) with a [transactional log](DeltaLog.md).

Changes to (the state of) a delta table are reflected as [actions](Action.md) and persisted to the transactional log (in [JSON format](Action.md#json)).

Delta Lake uses [OptimisticTransaction](OptimisticTransaction.md) for [transactional writes](TransactionalWrite.md). A [commit](OptimisticTransactionImpl.md#commit) is successful when the transaction can [write](OptimisticTransactionImpl.md#doCommit-write) the actions to a delta file (in the [transactional log](DeltaLog.md)). In case the delta file for the commit version already exists, the transaction is [retried](OptimisticTransactionImpl.md#checkAndRetry).

Structured queries can write (transactionally) to a delta table using the following interfaces:

* [WriteIntoDelta](WriteIntoDelta.md) command for batch queries (Spark SQL)

* [DeltaSink](DeltaSink.md) for streaming queries (Spark Structured Streaming)

More importantly, multiple queries can write to the same delta table simultaneously (at exactly the same time).

Delta Lake provides [DeltaTable API](DeltaTable.md) to programmatically access Delta tables. A delta table can be created [based on a parquet table](DeltaTable.md#convertToDelta) or [from scratch](DeltaTable.md#forPath).

Delta Lake supports batch and streaming queries (Spark SQL and Structured Streaming, respectively) using [delta](DeltaDataSource.md#DataSourceRegister) format.

In order to fine tune queries over data in Delta Lake use [options](DeltaOptions.md). Among the options [path](DeltaOptions.md#path) option is mandatory.

Delta Lake supports reading and writing in batch queries:

* [Batch reads](DeltaDataSource.md#RelationProvider) (as a `RelationProvider`)

* [Batch writes](DeltaDataSource.md#CreatableRelationProvider) (as a `CreatableRelationProvider`)

Delta Lake supports reading and writing in streaming queries:

* [Stream reads](DeltaDataSource.md#StreamSourceProvider) (as a `Source`)

* [Stream writes](DeltaDataSource.md#StreamSinkProvider) (as a `Sink`)

Delta Lake uses [LogStore](DeltaLog.md#store) abstraction to read and write physical log files and checkpoints (using [Hadoop FileSystem API](https://hadoop.apache.org/docs/current2/hadoop-project-dist/hadoop-common/filesystem/index.html)).
