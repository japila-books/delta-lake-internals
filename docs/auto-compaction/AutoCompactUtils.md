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
