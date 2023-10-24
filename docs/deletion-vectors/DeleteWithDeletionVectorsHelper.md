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

`processUnmodifiedData` calculates the following metrics (using the given `touchedFiles`):

* The total [number of modified rows](TouchedFileWithDV.md#numberOfModifiedRows)
* The number of [isFullyReplaced](TouchedFileWithDV.md#isFullyReplaced) data files

`processUnmodifiedData` splits (_partitions_) the given [TouchedFileWithDV](TouchedFileWithDV.md)s into fully removed ones and the others (based on [isFullyReplaced](TouchedFileWithDV.md#isFullyReplaced) flag).

`processUnmodifiedData`...FIXME

In the end, `processUnmodifiedData` returns a collection of the [RemoveFile](../RemoveFile.md) and [AddFile](../AddFile.md) actions along with the following metrics:

* `numModifiedRows`
* `numRemovedFiles`
* `numDeletionVectorsAdded`
* `numDeletionVectorsRemoved`
* `numDeletionVectorsUpdated`

---

`processUnmodifiedData` is used when:

* `DeleteCommand` is requested to [performDelete](../commands/delete/DeleteCommand.md#performDelete) (with [shouldWritePersistentDeletionVectors](../commands/delete/DeleteCommand.md#shouldWritePersistentDeletionVectors) enabled and supported)

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
