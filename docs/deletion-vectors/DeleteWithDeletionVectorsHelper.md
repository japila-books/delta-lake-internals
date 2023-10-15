# DeleteWithDeletionVectorsHelper

`DeleteWithDeletionVectorsHelper` is a [DeltaCommand](../commands/DeltaCommand.md) for `DeleteCommand` to [performDelete](../commands/delete/DeleteCommand.md#performDelete).

## createTargetDfForScanningForMatches { #createTargetDfForScanningForMatches }

```scala
createTargetDfForScanningForMatches(
  spark: SparkSession,
  target: LogicalPlan,
  fileIndex: TahoeFileIndex): DataFrame
```

`createTargetDfForScanningForMatches`...FIXME

---

`createTargetDfForScanningForMatches` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)

### replaceFileIndex { #replaceFileIndex }

```scala
replaceFileIndex(
  txn: OptimisticTransaction,
  nameToAddFileMap: Map[String, AddFile],
  matchedFileRowIndexSets: Seq[DeletionVectorResult]): Seq[TouchedFileWithDV]
```

`replaceFileIndex`...FIXME

## processUnmodifiedData { #processUnmodifiedData }

```scala
processUnmodifiedData(
  spark: SparkSession,
  touchedFiles: Seq[TouchedFileWithDV],
  snapshot: Snapshot): (Seq[FileAction], Map[String, Long])
```

`processUnmodifiedData`...FIXME

---

`processUnmodifiedData` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)

### getActionsWithStats { #getActionsWithStats }

```scala
getActionsWithStats(
  spark: SparkSession,
  addFilesWithNewDvs: Seq[AddFile],
  snapshot: Snapshot): Seq[AddFile]
```

`getActionsWithStats`...FIXME

## findTouchedFiles { #findTouchedFiles }

```scala
findTouchedFiles(
  sparkSession: SparkSession,
  txn: OptimisticTransaction,
  hasDVsEnabled: Boolean,
  deltaLog: DeltaLog,
  targetDf: DataFrame,
  fileIndex: TahoeFileIndex,
  condition: Expression): Seq[TouchedFileWithDV]
```

`findTouchedFiles`...FIXME

---

`findTouchedFiles` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete)

### findFilesWithMatchingRows { #findFilesWithMatchingRows }

```scala
findFilesWithMatchingRows(
  txn: OptimisticTransaction,
  nameToAddFileMap: Map[String, AddFile],
  matchedFileRowIndexSets: Seq[DeletionVectorResult]): Seq[TouchedFileWithDV]
```

`findFilesWithMatchingRows`...FIXME
