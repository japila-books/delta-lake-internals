# RecordChecksum

`RecordChecksum` is an [abstraction](#contract) of [checksum "recorders"](#implementations) that can [writeChecksumFile](#writeChecksumFile).

## Contract

### DeltaLog { #deltaLog }

```scala
deltaLog: DeltaLog
```

[DeltaLog](../DeltaLog.md) of the delta table to record the state of in a checksum file

### SparkSession { #spark }

```scala
spark: SparkSession
```

`SparkSession` ([Spark SQL]({{ book.spark_sql }}/SparkSession/))

## Implementations

* [OptimisticTransactionImpl](../OptimisticTransactionImpl.md)
* [ChecksumHook](ChecksumHook.md)

## CheckpointFileManager { #writer }

```scala
writer: CheckpointFileManager
```

`writer` [creates a CheckpointFileManager](../CheckpointFileManager.md#create) (for the [logPath](../DeltaLog.md#logPath) of this [DeltaLog](#deltaLog)).

??? note "Lazy Value"
    `writer` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## writeChecksumFile { #writeChecksumFile }

```scala
writeChecksumFile(
  txnId: String,
  snapshot: Snapshot): Unit
```

`writeChecksumFile`...FIXME

---

`writeChecksumFile` is used when:

* `ChecksumHook` is requested to [run](ChecksumHook.md#run)
