# OptimisticTransaction

**OptimisticTransaction** is an [OptimisticTransactionImpl](OptimisticTransactionImpl.md) (which _seems_ more of a class name change than anything more important).

When OptimisticTransaction (as a <<OptimisticTransactionImpl.md#, OptimisticTransactionImpl>>) is attempted to be <<OptimisticTransactionImpl.md#commit, committed>> (that does <<OptimisticTransactionImpl.md#doCommit, doCommit>> internally), the <<LogStore.md#, LogStore>> (of the <<deltaLog, DeltaLog>>) is requested to <<LogStore.md#write, write actions to a delta file>>, e.g. `_delta_log/00000000000000000001.json` for the attempt version `1`. Only when a `FileAlreadyExistsException` is thrown a commit is considered unsuccessful and <<OptimisticTransactionImpl.md#checkAndRetry, retried>>.

`OptimisticTransaction` can be associated with a thread as an <<active, active transaction>>.

## Creating Instance

OptimisticTransaction takes the following to be created:

* [[deltaLog]] DeltaLog.md[]
* [[snapshot]] Snapshot.md[]
* [[clock]] Clock

NOTE: The <<deltaLog, DeltaLog>> and <<snapshot, Snapshot>> are part of the <<OptimisticTransactionImpl.md#, OptimisticTransactionImpl>> contract (which in turn inherits them as a TransactionalWrite.md[] and changes to `val` from `def`).

`OptimisticTransaction` is created for changes to a <<deltaLog, delta table>> at a given <<snapshot, version>>.

`OptimisticTransaction` is created when DeltaLog is used for the following:

* DeltaLog.md#startTransaction[Starting a new transaction]

* DeltaLog.md#withNewTransaction[Executing a single-threaded operation (in a new transaction)] (for <<DeleteCommand.md#, DeleteCommand>>, <<MergeIntoCommand.md#, MergeIntoCommand>>, <<UpdateCommand.md#, UpdateCommand>>, and <<WriteIntoDelta.md#, WriteIntoDelta>> commands as well as for <<DeltaSink.md#, DeltaSink>> for <<DeltaSink.md#addBatch, adding a streaming micro-batch>>)

== [[active]] Active Thread-Local OptimisticTransaction

[source, scala]
----
active: ThreadLocal[OptimisticTransaction]
----

`active` is a Java [ThreadLocal]({{ java.api }}/java.base/java/lang/ThreadLocal.html) with the <<OptimisticTransaction.md#, OptimisticTransaction>> of the current thread.

> *ThreadLocal* provides thread-local variables. These variables differ from their normal counterparts in that each thread that accesses one (via its get or set method) has its own, independently initialized copy of the variable.

> *ThreadLocal* instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).

`active` is assigned to the current thread using <<setActive, setActive>> utility and cleared in <<clearActive, clearActive>>.

`active` is available using <<getActive, getActive>> utility.

There can only be one active OptimisticTransaction (or an `IllegalStateException` is thrown).

== [[utilities]] Utilities

=== [[setActive]] setActive

[source, scala]
----
setActive(
  txn: OptimisticTransaction): Unit
----

setActive simply associates the given OptimisticTransaction as <<active, active>> with the current thread.

setActive throws an `IllegalStateException` if there is an active OptimisticTransaction already associated:

```
Cannot set a new txn as active when one is already active
```

setActive is used when `DeltaLog` is requested to <<DeltaLog.md#withNewTransaction, execute an operation in a new transaction>>.

=== [[clearActive]] clearActive

[source, scala]
----
clearActive(): Unit
----

clearActive simply clears the <<active, active>> transaction (so no transaction is associated with a thread).

clearActive is used when `DeltaLog` is requested to <<DeltaLog.md#withNewTransaction, execute an operation in a new transaction>>.

=== [[getActive]] getActive

[source, scala]
----
getActive(): Option[OptimisticTransaction]
----

getActive simply returns the <<active, active>> transaction.

getActive _seems_ unused.

== [[logging]] Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.OptimisticTransaction` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

[source,plaintext]
----
log4j.logger.org.apache.spark.sql.delta.OptimisticTransaction=ALL
----

Refer to [Logging](spark-logging.md).

== [[demo]] Demo

[source,scala]
----
import org.apache.spark.sql.delta.DeltaLog
val dir = "/tmp/delta/users"
val log = DeltaLog.forTable(spark, dir)

val txn = log.startTransaction()

// ...changes to a delta table...
val addFile = AddFile("foo", Map.empty, 1L, System.currentTimeMillis(), dataChange = true)
val removeFile = addFile.remove
val actions = addFile :: removeFile :: Nil

txn.commit(actions, op)

// You could do the following instead

deltaLog.withNewTransaction { txn =>
  // ...transactional changes to a delta table
}
----
