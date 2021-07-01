# OptimisticTransaction

`OptimisticTransaction` is an [OptimisticTransactionImpl](OptimisticTransactionImpl.md) (which _seems_ more of a class name change than anything more important).

`OptimisticTransaction` is [created](#creating-instance) for changes to a [delta table](#deltaLog) at a given [version](#snapshot).

When `OptimisticTransaction` (as a [OptimisticTransactionImpl](OptimisticTransactionImpl.md)) is about to be [committed](OptimisticTransactionImpl.md#commit) (that does [doCommit](OptimisticTransactionImpl.md#doCommit) internally), the [LogStore](storage/LogStore.md) (of the [delta table](#deltaLog)) is requested to [write actions to a delta file](storage/LogStore.md#write) (e.g. `_delta_log/00000000000000000001.json` for the attempt version `1`). Unless a `FileAlreadyExistsException` is thrown a commit is considered successful or [retried](OptimisticTransactionImpl.md#checkAndRetry).

`OptimisticTransaction` can be associated with a thread as an [active transaction](#active).

## Demo

```text
import org.apache.spark.sql.delta.DeltaLog
val dir = "/tmp/delta/users"
val log = DeltaLog.forTable(spark, dir)

val txn = log.startTransaction()

// ...changes to a delta table...
val addFile = AddFile("foo", Map.empty, 1L, System.currentTimeMillis(), dataChange = true)
val removeFile = addFile.remove
val actions = addFile :: removeFile :: Nil

txn.commit(actions, op)
```

Alternatively, you could do the following instead.

```text
deltaLog.withNewTransaction { txn =>
  // ...transactional changes to a delta table
}
```

## Creating Instance

`OptimisticTransaction` takes the following to be created:

* <span id="deltaLog"> [DeltaLog](DeltaLog.md)
* <span id="snapshot"> [Snapshot](Snapshot.md)
* <span id="clock"> `Clock`

!!! NOTE
    The [DeltaLog](#deltaLog) and [Snapshot](#snapshot) are part of the [OptimisticTransactionImpl](OptimisticTransactionImpl.md) abstraction (which in turn inherits them as a [TransactionalWrite](TransactionalWrite.md) and simply changes to `val` from `def`).

`OptimisticTransaction` is created when `DeltaLog` is used for the following:

* [Starting a new transaction](DeltaLog.md#startTransaction)
* [Executing a single-threaded operation (in a new transaction)](DeltaLog.md#withNewTransaction)

## <span id="active"> Active Thread-Local OptimisticTransaction

```scala
active: ThreadLocal[OptimisticTransaction]
```

`active` is a Java [ThreadLocal]({{ java.api }}/java.base/java/lang/ThreadLocal.html) with the `OptimisticTransaction` of the current thread.

!!! quote "ThreadLocal"
    `ThreadLocal` provides thread-local variables. These variables differ from their normal counterparts in that each thread that accesses one (via its get or set method) has its own, independently initialized copy of the variable.

    `ThreadLocal` instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).

`active` is assigned to the current thread using [setActive](#setActive) utility and cleared in [clearActive](#clearActive).

`active` is available using [getActive](#getActive) utility.

There can only be one active `OptimisticTransaction` (or an `IllegalStateException` is thrown).

## <span id="setActive"> setActive

```scala
setActive(
  txn: OptimisticTransaction): Unit
```

`setActive` associates the given `OptimisticTransaction` as [active](#active) with the current thread.

`setActive` throws an `IllegalStateException` if there is an active OptimisticTransaction already associated:

```text
Cannot set a new txn as active when one is already active
```

`setActive` is used when:

* `DeltaLog` is requested to [execute an operation in a new transaction](DeltaLog.md#withNewTransaction)

## <span id="clearActive"> clearActive

```scala
clearActive(): Unit
```

`clearActive` clears the [active](#active) transaction (so no transaction is associated with the current thread).

`clearActive` is used when:

* `DeltaLog` is requested to [execute an operation in a new transaction](DeltaLog.md#withNewTransaction)

## <span id="getActive"> getActive

```scala
getActive(): Option[OptimisticTransaction]
```

getActive returns the [active](#active) transaction (if [available](#setActive)).

getActive _seems_ unused.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.delta.OptimisticTransaction` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.delta.OptimisticTransaction=ALL
```

Refer to [Logging](spark-logging.md).
