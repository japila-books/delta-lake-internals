# DMLWithDeletionVectorsHelper

## createTargetDfForScanningForMatches { #createTargetDfForScanningForMatches }

```scala
createTargetDfForScanningForMatches(
  spark: SparkSession,
  target: LogicalPlan,
  fileIndex: TahoeFileIndex): DataFrame
```

`createTargetDfForScanningForMatches` creates a `DataFrame` with [replaceFileIndex](#replaceFileIndex) logical operator (based on the given `target` and [TahoeFileIndex](../TahoeFileIndex.md))

---

`createTargetDfForScanningForMatches` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete) (with [deletion vectors enabled](../commands/delete/DeleteCommand.md#shouldWritePersistentDeletionVectors))
* `UpdateCommand` is requested to [performUpdate](../commands/update/UpdateCommand.md#performUpdate) (with [deletion vectors enabled](../commands/update/UpdateCommand.md#shouldWritePersistentDeletionVectors))

### replaceFileIndex { #replaceFileIndex }

```scala
replaceFileIndex(
  target: LogicalPlan,
  fileIndex: TahoeFileIndex): LogicalPlan
```

`replaceFileIndex`...FIXME
