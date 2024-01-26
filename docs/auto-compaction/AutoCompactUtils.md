# AutoCompactUtils

## prepareAutoCompactRequest { #prepareAutoCompactRequest }

```scala
prepareAutoCompactRequest(
  spark: SparkSession,
  txn: OptimisticTransactionImpl,
  postCommitSnapshot: Snapshot,
  partitionsAddedToOpt: Option[PartitionKeySet],
  opType: String,
  maxDeletedRowsRatio: Option[Double]): AutoCompactRequest
```

`prepareAutoCompactRequest`...FIXME

---

`prepareAutoCompactRequest` is used when:

* `AutoCompactBase` is requested to [compactIfNecessary](AutoCompactBase.md#compactIfNecessary)

## isQualifiedForAutoCompact { #isQualifiedForAutoCompact }

```scala
isQualifiedForAutoCompact(
  spark: SparkSession,
  txn: OptimisticTransactionImpl): Boolean
```

`isQualifiedForAutoCompact` is disabled (`false`) when there is no transaction commit (i.e., no [txnExecutionTimeMs](../OptimisticTransactionImpl.md#txnExecutionTimeMs) in the given [OptimisticTransactionImpl](../OptimisticTransactionImpl.md)).

`isQualifiedForAutoCompact` is enabled (`true`) for [isModifiedPartitionsOnlyAutoCompactEnabled](#isModifiedPartitionsOnlyAutoCompactEnabled) disabled.

`isQualifiedForAutoCompact` is enabled (`true`) if either holds:

1. [isNonBlindAppendAutoCompactEnabled](#isNonBlindAppendAutoCompactEnabled) is disabled
1. The given [OptimisticTransactionImpl](../OptimisticTransactionImpl.md) is not [blind-append](../OptimisticTransactionImpl.md#isBlindAppend)

---

`isQualifiedForAutoCompact` is used when:

* `AutoCompactBase` is requested to [shouldSkipAutoCompact](AutoCompactBase.md#shouldSkipAutoCompact)

## isModifiedPartitionsOnlyAutoCompactEnabled { #isModifiedPartitionsOnlyAutoCompactEnabled }

```scala
isModifiedPartitionsOnlyAutoCompactEnabled(
  spark: SparkSession): Boolean
```

`isModifiedPartitionsOnlyAutoCompactEnabled` says whether [Auto Compaction](index.md) should run on modified partitions only.

`isModifiedPartitionsOnlyAutoCompactEnabled` is the value of [spark.databricks.delta.autoCompact.modifiedPartitionsOnly.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.modifiedPartitionsOnly.enabled) configuration property (in the given `SparkSession`).

---

`isModifiedPartitionsOnlyAutoCompactEnabled` is used when:

* `AutoCompactUtils` is requested to [choosePartitionsBasedOnMinNumSmallFiles](#choosePartitionsBasedOnMinNumSmallFiles), [isQualifiedForAutoCompact](#isQualifiedForAutoCompact), [reserveTablePartitions](#reserveTablePartitions)

## isNonBlindAppendAutoCompactEnabled { #isNonBlindAppendAutoCompactEnabled }

```scala
isNonBlindAppendAutoCompactEnabled(
  spark: SparkSession): Boolean
```

`isNonBlindAppendAutoCompactEnabled` is the value of [spark.databricks.delta.autoCompact.nonBlindAppend.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.nonBlindAppend.enabled) configuration property (in the given `SparkSession`).

---

`isNonBlindAppendAutoCompactEnabled` is used when:

* `AutoCompactUtils` is requested to [isQualifiedForAutoCompact](#isQualifiedForAutoCompact)
