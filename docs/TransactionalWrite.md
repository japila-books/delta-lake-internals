# TransactionalWrite

*TransactionalWrite* is an <<contract, abstraction>> of <<implementations, optimistic transactional writers>> that can <<writeFiles, write a structured query out>> to a <<deltaLog, Delta table>>.

== [[contract]] Contract

=== [[deltaLog]] deltaLog

[source,scala]
----
deltaLog: DeltaLog
----

DeltaLog.adoc[] (of a delta table) that this transaction is changing

Used when:

* `OptimisticTransactionImpl` is requested to <<OptimisticTransactionImpl.adoc#prepareCommit, prepare a commit>>, <<OptimisticTransactionImpl.adoc#doCommit, doCommit>> (after <<DeltaLog.adoc#lockInterruptibly, acquiring an interruptible lock on the log>>), <<OptimisticTransactionImpl.adoc#checkAndRetry, checkAndRetry>>, and <<OptimisticTransactionImpl.adoc#postCommit, perform post-commit operations>> (and execute <<Checkpoints.adoc#checkpoint, delta log checkpoint>>)

* <<ConvertToDeltaCommand.adoc#, ConvertToDeltaCommand>> and <<MergeIntoCommand.adoc#, MergeIntoCommand>> are executed

* `DeltaCommand` is requested to <<DeltaCommand.adoc#buildBaseRelation, buildBaseRelation>>

* `DeltaLog` is requested to <<DeltaLog.adoc#createDataFrame, createDataFrame>>

* TransactionalWrite is requested to <<writeFiles, write a structured query out to a delta table>>

=== [[metadata]] metadata

[source, scala]
----
metadata: Metadata
----

Metadata.adoc[] (of the <<deltaLog, delta table>>) that this transaction is changing

=== [[protocol]] protocol

[source, scala]
----
protocol: Protocol
----

Protocol.adoc[] (of the <<deltaLog, delta table>>) that this transaction is changing

Used when AlterTableSetPropertiesDeltaCommand.adoc[] is executed (to DeltaConfigs.adoc#verifyProtocolVersionRequirements[verifyProtocolVersionRequirements])

=== [[snapshot]] snapshot

[source, scala]
----
snapshot: Snapshot
----

Snapshot.adoc[] (of the <<deltaLog, delta table>>) that this transaction is <<OptimisticTransactionImpl.adoc#readVersion, reading at>>

== [[implementations]][[self]] Implementations

OptimisticTransaction.adoc[] is the default and only known TransactionalWrite in Delta Lake (indirectly as a OptimisticTransactionImpl.adoc[]).

## <span id="writeFiles"> Writing Data Out (Result Of Structured Query)

```scala
writeFiles(
  data: Dataset[_]): Seq[AddFile]
writeFiles(
  data: Dataset[_],
  writeOptions: Option[DeltaOptions]): Seq[AddFile]
writeFiles(
  data: Dataset[_],
  isOptimize: Boolean): Seq[AddFile]
writeFiles(
  data: Dataset[_],
  writeOptions: Option[DeltaOptions],
  isOptimize: Boolean): Seq[AddFile]
```

`writeFiles` creates a [DeltaInvariantCheckerExec](DeltaInvariantCheckerExec.md) and a [DelayedCommitProtocol](DelayedCommitProtocol.md) to write out files to the [data path](DeltaLog.md#dataPath) (of the [DeltaLog](#deltaLog)).

!!! note
    `writeFiles` uses Spark SQL's `FileFormatWriter` utility to write out a result of a streaming query.

    Read up on [FileFormatWriter](https://jaceklaskowski.github.io/mastering-spark-sql-book/spark-sql-FileFormatWriter/) in [The Internals of Spark SQL](https://jaceklaskowski.github.io/mastering-spark-sql-book) online book.

`writeFiles` is executed within `SQLExecution.withNewExecutionId`.

!!! note
    `writeFiles` can be tracked using web UI or `SQLAppStatusListener` (using `SparkListenerSQLExecutionStart` and `SparkListenerSQLExecutionEnd` events).

In the end, `writeFiles` returns the [addedStatuses](DelayedCommitProtocol.md#addedStatuses) of the `DelayedCommitProtocol` committer.

Internally, `writeFiles` turns the [hasWritten](#hasWritten) flag on (`true`).

NOTE: After `writeFiles`, no [metadata updates](OptimisticTransactionImpl.md#updateMetadata-AssertionError-hasWritten) in the transaction are permitted.

`writeFiles` [normalize](#normalizeData) the given `data` dataset (based on the [partitionColumns](Metadata.md#partitionColumns) of the [Metadata](OptimisticTransactionImpl.md#metadata)).

`writeFiles` [getPartitioningColumns](#getPartitioningColumns) based on the [partitionSchema](Metadata.md#partitionSchema) of the [Metadata](OptimisticTransactionImpl.md#metadata).

<span id="writeFiles-committer">
writeFiles [creates a DelayedCommitProtocol committer](#getCommitter) for the [data path](DeltaLog.md#dataPath) of the [DeltaLog](#deltaLog).

`writeFiles` [gets the invariants](Invariants.md#getFromSchema) from the [schema](Metadata.md#schema) of the [Metadata](OptimisticTransactionImpl.md#metadata).

<span id="writeFiles-DeltaInvariantCheckerExec"><span id="writeFiles-FileFormatWriter">
`writeFiles` requests a new Execution ID (that is used to track all Spark jobs of `FileFormatWriter.write` in Spark SQL) with a physical query plan of a new [DeltaInvariantCheckerExec](DeltaInvariantCheckerExec.md) unary physical operator (with the executed plan of the normalized query execution as the child operator).

`writeFiles` is used when:

* [DeleteCommand](DeleteCommand.md), [MergeIntoCommand](commands/MergeIntoCommand.md), [UpdateCommand](UpdateCommand.md), and [WriteIntoDelta](WriteIntoDelta.md) commands are executed
* `DeltaSink` is requested to [add a streaming micro-batch](DeltaSink.md#addBatch)

== [[getCommitter]] Creating Committer

[source, scala]
----
getCommitter(
  outputPath: Path): DelayedCommitProtocol
----

getCommitter creates a new <<DelayedCommitProtocol.adoc#, DelayedCommitProtocol>> with the *delta* job ID and the given `outputPath` (and no random prefix).

getCommitter is used when TransactionalWrite is requested to <<writeFiles, write out a streaming query>>.

== [[makeOutputNullable]] makeOutputNullable Method

[source, scala]
----
makeOutputNullable(
  output: Seq[Attribute]): Seq[Attribute]
----

makeOutputNullable...FIXME

makeOutputNullable is used when...FIXME

== [[normalizeData]] normalizeData Method

[source, scala]
----
normalizeData(
  data: Dataset[_],
  partitionCols: Seq[String]): (QueryExecution, Seq[Attribute])
----

normalizeData...FIXME

normalizeData is used when...FIXME

== [[getPartitioningColumns]] getPartitioningColumns Method

[source, scala]
----
getPartitioningColumns(
  partitionSchema: StructType,
  output: Seq[Attribute],
  colsDropped: Boolean): Seq[Attribute]
----

getPartitioningColumns...FIXME

getPartitioningColumns is used when...FIXME

== [[hasWritten]] hasWritten Flag

[source, scala]
----
hasWritten: Boolean = false
----

TransactionalWrite uses the hasWritten internal registry to prevent `OptimisticTransactionImpl` from <<OptimisticTransactionImpl.adoc#updateMetadata, updating metadata>> after <<writeFiles, having written out any files>>.

hasWritten is initially turned off (`false`). It can be turned on (`true`) when TransactionalWrite is requested to <<writeFiles, write files out>>.
