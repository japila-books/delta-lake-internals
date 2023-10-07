# DeletionVectorBitmapGenerator

## buildRowIndexSetsForFilesMatchingCondition { #buildRowIndexSetsForFilesMatchingCondition }

```scala
buildRowIndexSetsForFilesMatchingCondition(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  tableHasDVs: Boolean,
  targetDf: DataFrame,
  candidateFiles: Seq[AddFile],
  condition: Expression): Seq[DeletionVectorResult]
```

`buildRowIndexSetsForFilesMatchingCondition`...FIXME

---

`buildRowIndexSetsForFilesMatchingCondition` is used when:

* `DeleteWithDeletionVectorsHelper` is requested to [findTouchedFiles](DeleteWithDeletionVectorsHelper.md#findTouchedFiles)

### buildDeletionVectors { #buildDeletionVectors }

```scala
buildDeletionVectors(
  spark: SparkSession,
  target: DataFrame,
  targetDeltaLog: DeltaLog,
  deltaTxn: OptimisticTransaction): Seq[DeletionVectorResult]
```

`buildDeletionVectors`...FIXME
