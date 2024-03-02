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

`prepareAutoCompactRequest` creates an [AutoCompactRequest](AutoCompactRequest.md) based on [reserveTablePartitions](#reserveTablePartitions) and a [partition predicate](#createPartitionPredicate) (for the given [postCommitSnapshot](../Snapshot.md) and the reserved partitions).

---

`prepareAutoCompactRequest` is used when:

* `AutoCompactBase` is requested to [compactIfNecessary](AutoCompactBase.md#compactIfNecessary)

### createPartitionPredicate { #createPartitionPredicate }

```scala
createPartitionPredicate(
  postCommitSnapshot: Snapshot,
  partitions: PartitionKeySet): Seq[Expression]
```

`createPartitionPredicate`...FIXME

### reserveTablePartitions { #reserveTablePartitions }

```scala
reserveTablePartitions(
  spark: SparkSession,
  deltaLog: DeltaLog,
  postCommitSnapshot: Snapshot,
  partitionsAddedToOpt: Option[PartitionKeySet],
  opType: String,
  maxDeletedRowsRatio: Option[Double]): (Boolean, PartitionKeySet)
```

??? warning "`maxDeletedRowsRatio` always undefined (`None`)"
    `maxDeletedRowsRatio` is always `None` as that's what [prepareAutoCompactRequest](#prepareAutoCompactRequest) is called with when [compacting if necessary](AutoCompactBase.md#compactIfNecessary).
  
??? note "`opType` always `delta.commit.hooks.autoOptimize`"
    `opType` is always [delta.commit.hooks.autoOptimize](AutoCompactBase.md#OP_TYPE).

??? note "`partitionsAddedToOpt`"
    `partitionsAddedToOpt` is the [set of distinct partitions that contain added files by the current transaction](../OptimisticTransactionImpl.md#partitionsAddedToOpt).

??? note "Noop when the given `partitionsAddedToOpt` is empty"
    `reserveTablePartitions` does nothing and exits early (_noop_) when the given `partitionsAddedToOpt` is empty.

    `reserveTablePartitions` returns `(false, Set.empty[PartitionKey])`.

`reserveTablePartitions` finds _free partitions_ to perform auto compaction on based on the two internal flags:

* [isModifiedPartitionsOnlyAutoCompactEnabled](#isModifiedPartitionsOnlyAutoCompactEnabled)
* [reservePartitionEnabled](#reservePartitionEnabled)

When both enabled, `reserveTablePartitions` [filterFreePartitions](#filterFreePartitions). Otherwise, the given `partitionsAddedToOpt` is used as-is.

`reserveTablePartitions` does nothing (_noop_) when there is no free partition. `reserveTablePartitions` returns `(false, Set.empty[PartitionKey])`.

`reserveTablePartitions` [choosePartitionsBasedOnMinNumSmallFiles](#choosePartitionsBasedOnMinNumSmallFiles) with the free partitions.

With `shouldCompactBasedOnNumFiles` enabled and no `chosenPartitionsBasedOnNumFiles`, `reserveTablePartitions` does nothing more and returns `(true, Set.empty[PartitionKey])`.

`reserveTablePartitions` [choosePartitionsBasedOnDVs](#choosePartitionsBasedOnDVs) with the free partitions.

`reserveTablePartitions`...FIXME

### choosePartitionsBasedOnMinNumSmallFiles { #choosePartitionsBasedOnMinNumSmallFiles }

```scala
choosePartitionsBasedOnMinNumSmallFiles(
  spark: SparkSession,
  deltaLog: DeltaLog,
  postCommitSnapshot: Snapshot,
  freePartitionsAddedTo: PartitionKeySet): ChosenPartitionsResult
```

`choosePartitionsBasedOnMinNumSmallFiles`...FIXME

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

### isNonBlindAppendAutoCompactEnabled { #isNonBlindAppendAutoCompactEnabled }

```scala
isNonBlindAppendAutoCompactEnabled(
  spark: SparkSession): Boolean
```

`isNonBlindAppendAutoCompactEnabled` is the value of [spark.databricks.delta.autoCompact.nonBlindAppend.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.nonBlindAppend.enabled) configuration property (in the given `SparkSession`).

## isModifiedPartitionsOnlyAutoCompactEnabled { #isModifiedPartitionsOnlyAutoCompactEnabled }

```scala
isModifiedPartitionsOnlyAutoCompactEnabled(
  spark: SparkSession): Boolean
```

`isModifiedPartitionsOnlyAutoCompactEnabled` says whether [Auto Compaction](index.md) should run on modified partitions only.

---

`isModifiedPartitionsOnlyAutoCompactEnabled` is the value of [spark.databricks.delta.autoCompact.modifiedPartitionsOnly.enabled](../configuration-properties/index.md#spark.databricks.delta.autoCompact.modifiedPartitionsOnly.enabled) configuration property (in the given `SparkSession`).

---

`isModifiedPartitionsOnlyAutoCompactEnabled` is used when:

* `AutoCompactUtils` is requested to [choosePartitionsBasedOnMinNumSmallFiles](#choosePartitionsBasedOnMinNumSmallFiles), [isQualifiedForAutoCompact](#isQualifiedForAutoCompact), [reserveTablePartitions](#reserveTablePartitions)
