# TransactionalWrite

`TransactionalWrite` is an [abstraction](#contract) of [optimistic transactional writers](#implementations) that can [write a structured query out](#writeFiles) to a [Delta table](#deltaLog).

## Contract

### <span id="deltaLog"> DeltaLog

```scala
deltaLog: DeltaLog
```

[DeltaLog](DeltaLog.md) (of a delta table) that this transaction is changing

Used when:

* [ActiveOptimisticTransactionRule](ActiveOptimisticTransactionRule.md) logical rule is executed
* `OptimisticTransactionImpl` is requested to [prepare a commit](OptimisticTransactionImpl.md#prepareCommit), [doCommit](OptimisticTransactionImpl.md#doCommit), [checkAndRetry](OptimisticTransactionImpl.md#checkAndRetry), and [perform post-commit operations](OptimisticTransactionImpl.md#postCommit) (and execute [delta log checkpoint](Checkpoints.md#checkpoint))
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed
* `DeltaCommand` is requested to [buildBaseRelation](commands/DeltaCommand.md#buildBaseRelation) and [commitLarge](commands/DeltaCommand.md#commitLarge)
* [MergeIntoCommand](commands/merge/MergeIntoCommand.md) is executed
* `TransactionalWrite` is requested to [write a structured query out to a delta table](#writeFiles)
* [GenerateSymlinkManifest](GenerateSymlinkManifest.md) post-commit hook is executed
* `ImplicitMetadataOperation` is requested to [updateMetadata](ImplicitMetadataOperation.md#updateMetadata)
* `DeltaSink` is requested to [addBatch](DeltaSink.md#addBatch)

### <span id="metadata"> Metadata

```scala
metadata: Metadata
```

[Metadata](Metadata.md) (of the [delta table](#deltaLog)) that this transaction is changing

### <span id="protocol"> Protocol

```scala
protocol: Protocol
```

[Protocol](Protocol.md) (of the [delta table](#deltaLog)) that this transaction is changing

Used when:

* `OptimisticTransactionImpl` is requested to [updateMetadata](OptimisticTransactionImpl.md#updateMetadata), [verifyNewMetadata](OptimisticTransactionImpl.md#verifyNewMetadata) and [prepareCommit](OptimisticTransactionImpl.md#prepareCommit)
* [ConvertToDeltaCommand](commands/convert/ConvertToDeltaCommand.md) is executed

### <span id="snapshot"> Snapshot

```scala
snapshot: Snapshot
```

[Snapshot](Snapshot.md) (of the [delta table](#deltaLog)) that this transaction is [reading at](OptimisticTransactionImpl.md#readVersion)

## Implementations

* [OptimisticTransaction](OptimisticTransaction.md)

## <span id="hasWritten"> hasWritten Flag

```scala
hasWritten: Boolean = false
```

`TransactionalWrite` uses `hasWritten` internal registry to prevent `OptimisticTransactionImpl` from [updating metadata](OptimisticTransactionImpl.md#updateMetadata) after [having written out files](#writeFiles).

`hasWritten` is initially `false` and changes to `true` after [having written out files](#writeFiles).

## <span id="writeFiles"> Writing Data Out (Result Of Structured Query)

```scala
writeFiles(
  data: Dataset[_]): Seq[FileAction]
writeFiles(
  data: Dataset[_],
  writeOptions: Option[DeltaOptions]): Seq[FileAction]
```

`writeFiles` creates a [DeltaInvariantCheckerExec](constraints/DeltaInvariantCheckerExec.md) and a [DelayedCommitProtocol](DelayedCommitProtocol.md) to write out files to the [data path](DeltaLog.md#dataPath) (of the [DeltaLog](#deltaLog)).

??? tip "Learn more"
    `writeFiles` uses Spark SQL's `FileFormatWriter` utility to write out a result of a streaming query.

    Learn about [FileFormatWriter]({{ book.spark_sql }}/FileFormatWriter) in [The Internals of Spark SQL]({{ book.spark_sql }}) online book.

`writeFiles` is executed within `SQLExecution.withNewExecutionId`.

??? tip "Learn more"
    `writeFiles` can be tracked using web UI or `SQLAppStatusListener` (using `SparkListenerSQLExecutionStart` and `SparkListenerSQLExecutionEnd` events).

    Learn about [SQLAppStatusListener]({{ book.spark_sql }}/SQLAppStatusListener) in [The Internals of Spark SQL]({{ book.spark_sql }}) online book.

In the end, `writeFiles` returns the [addedStatuses](DelayedCommitProtocol.md#addedStatuses) of the `DelayedCommitProtocol` committer.

Internally, `writeFiles` turns the [hasWritten](#hasWritten) flag on (`true`).

!!! note
    After `writeFiles`, no [metadata updates](OptimisticTransactionImpl.md#updateMetadata-AssertionError-hasWritten) in the transaction are permitted.

`writeFiles` [normalize](#normalizeData) the given `data` dataset (based on the [partitionColumns](Metadata.md#partitionColumns) of the [Metadata](OptimisticTransactionImpl.md#metadata)).

`writeFiles` [getPartitioningColumns](#getPartitioningColumns) based on the [partitionSchema](Metadata.md#partitionSchema) of the [Metadata](OptimisticTransactionImpl.md#metadata).

### <span id="writeFiles-committer"> DelayedCommitProtocol Committer

`writeFiles` [creates a DelayedCommitProtocol committer](#getCommitter) for the [data path](DeltaLog.md#dataPath) of the [DeltaLog](#deltaLog).

`writeFiles` [gets the invariants](constraints/Invariants.md#getFromSchema) from the [schema](Metadata.md#schema) of the [Metadata](OptimisticTransactionImpl.md#metadata).

### <span id="writeFiles-DeltaInvariantCheckerExec"><span id="writeFiles-FileFormatWriter"> DeltaInvariantCheckerExec

`writeFiles` requests a new Execution ID (that is used to track all Spark jobs of `FileFormatWriter.write` in Spark SQL) with a physical query plan of a new [DeltaInvariantCheckerExec](constraints/DeltaInvariantCheckerExec.md) unary physical operator (with the executed plan of the normalized query execution as the child operator).

### <span id="getCommitter"> Creating Committer

```scala
getCommitter(
  outputPath: Path): DelayedCommitProtocol
```

`getCommitter` creates a new [DelayedCommitProtocol](DelayedCommitProtocol.md) with the **delta** job ID and the given `outputPath` (and no random prefix).

### <span id="getPartitioningColumns"> getPartitioningColumns

```scala
getPartitioningColumns(
  partitionSchema: StructType,
  output: Seq[Attribute],
  colsDropped: Boolean): Seq[Attribute]
```

`getPartitioningColumns`...FIXME

### <span id="normalizeData"> normalizeData

```scala
normalizeData(
  data: Dataset[_],
  partitionCols: Seq[String]): (QueryExecution, Seq[Attribute])
```

`normalizeData`...FIXME

### <span id="makeOutputNullable"> makeOutputNullable

```scala
makeOutputNullable(
  output: Seq[Attribute]): Seq[Attribute]
```

`makeOutputNullable`...FIXME

### <span id="writeFiles-usage"> Usage

`writeFiles` is used when:

* [DeleteCommand](commands/delete/DeleteCommand.md), [MergeIntoCommand](commands/merge/MergeIntoCommand.md), [UpdateCommand](commands/update/UpdateCommand.md), and [WriteIntoDelta](commands/WriteIntoDelta.md) commands are executed
* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)
